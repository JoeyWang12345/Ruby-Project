class ShoppingCartsController < ApplicationController
  before_action :find_shopping_cart, only: [:update, :destroy]
  def index # 列出购物车列表
    fetch_home_data # 获得所有分类和购物车数量
    # 通过user_uuid找到所有的购物车
    @shopping_carts = ShoppingCart.by_user_uuid(session[:user_uuid])
          .order(id: "desc")
              # .includes([:product => [:main_product_image]]) # 产品图片先不要
  end

  # 加入购物车，对应create
  # 需要：加入购物车的商品数量，商品ID，uuid
  def create
    # 在列表页面点击加入购物车，amount为nil，转换成整数为0
    amount = params[:amount].to_i
    # 如果小于等于0，自动设为1
    amount = (amount <= 0) ? 1 : amount
    puts amount
    # 找到商品
    @product = Product.find(params[:product_id])
    # 第一次把商品加入购物车，对应创建操作；第二次点击时，如果该商品已经在购物车中，仅改变其数量，否则创建
    @shopping_cart = ShoppingCart.create_or_update!({
        user_uuid: session[:user_uuid],
        product_id: params[:product_id], # 从前端传递过来的
        amount: amount
                                                    })
    # 添加购物车的操作是异步的，需要返回模板页面来展示刚加入购物车的商品
    # 所以不再使用父模板渲染(application.html.erb)
    # 实际上是弹出一个小窗口
    render layout: false
  end

  def update
    # 如果有购物车
    if @shopping_cart
      amount = params[:amount].to_i
      amount = amount <= 0 ? 1 :amount
      @shopping_cart.update_attribute :amount, amount
    end

    redirect_to shopping_carts_path
  end

  def destroy
    @shopping_cart.destroy if @shopping_cart

    redirect_to shopping_carts_path
  end

  private
  def find_shopping_cart
    # 找到匹配当前uuid的所有购物车
    @shopping_cart = ShoppingCart.by_user_uuid(session[:user_uuid])
                     .where(id: params[:id]).first
  end
end

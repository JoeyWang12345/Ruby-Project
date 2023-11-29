class OrdersController < ApplicationController
  before_action :auth_user
  # 点击去结算时打开的页面
  def new
    fetch_home_data
    # 取得购物车信息(用户一定已经登录)，这样new页面中就能读取到
    @shopping_carts = ShoppingCart.by_user_uuid(current_user.uuid)
                      .order(id: "desc")
  end

  # 确认订单
  def create
    # 局部变量前面没有@，需要传递到外部时要加@
    shopping_carts = ShoppingCart.by_user_uuid(current_user.uuid)
                      .order(id: "desc").includes(:product)
    # 保护(若购物车为空，无法创建订单)
    if shopping_carts.blank?
      redirect_to shopping_carts_path
      return
    end
    # 找到地址该订单的地址
    address = current_user.addresses.find(params[:address_id])
    # 根据当前用户，地址和购物车信息创建订单
    Order.create_order!(current_user, address, shopping_carts)

    # 跳转到支付页面
    redirect_to payments_path
  end
end

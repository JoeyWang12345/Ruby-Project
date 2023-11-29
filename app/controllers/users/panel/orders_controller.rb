class Users::Panel::OrdersController < Users::Panel::BaseController
  # 用户的所有订单
  def index
    # 获得订单的地址
    @orders = current_user.orders.page(params[:page] || 1)
                          .per_page(params[:per_page] || 10).includes([:address]).order(id: "desc")
    # [:product => [:main_product_image]] 产品图片没放进去
  end
end

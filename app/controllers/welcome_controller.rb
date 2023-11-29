# 主页面
class WelcomeController < ApplicationController
  def index
    fetch_home_data
    @products = Product.onshelf.page(params[:page] || 1) # 所有上架的商品数据
       .per_page(params[:per_page] || 12).order(id: "desc")
             # .includes(:product_images) # 图片没实现
  end
end

class ProductsController < ApplicationController
  before_action :fetch_home_data
  def search
    @products = Product.where("title like :title", title: "%#{params[:w]}%")
                       .order(id: "desc").page(params[:page] || 1).per_page(params[:per_page] || 12)
    # .includes(:main_product_image)

    # 如果当前类别ID不为空，即存在
    unless params[:category_id].blank?
      # 查找链，直接根据params[:category_id]的值去查找
      # 因为这些东西都是在拼装SQL语句，并没有真的查询
      @products = @products.where(category_id: params[:category_id])
    end
    # 跳转到首页
    render 'welcome/index'
  end
  def show
    @product = Product.find(params[:id])
  end
end
class CategoriesController < ApplicationController
  def show # 查看分类页面数据
    fetch_home_data # 获得分类列表
    @category = Category.find(params[:id]) # 要查询的分类数据
    @products = @category.products.onshelf.page(params[:page] || 1) # 该分类下的商品数据
       .per_page(params[:per_page] || 12).order(id: "desc")
    # .includes(:product_images) # 图片没实现
  end
end
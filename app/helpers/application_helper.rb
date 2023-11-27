module ApplicationHelper
  # product模型和参数
  def show_add_to_cart(product, options = {})
    # html_class，通过options传进来样式，通过js操作
    html_class = "btn btn-danger add-to-cart-btn" # 便于通过options传递进来的参数定制按钮样式
    # options中如有自定义的就加进来
    # 这块有个空格，TMD
    html_class += " #{options[:html_class]}" unless options[:html_class].blank?
    # font-awesome，输出图标，可以显示加入进程
    # 目前把旋转关了
    link_to "<i class='fa fa-spinner'></i> 加入购物车".html_safe, shopping_carts_path, class:
      html_class, 'data-product-id': product.id # 自定义的产品id属性(点击时通过js取得product_id，判断哪个商品要加入)
  end
end

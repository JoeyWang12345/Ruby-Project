class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # 设置过滤器，用户访问任何页面时，如果没有uuid，就需要新设一个
  before_action :set_browser_uuid

  protected
  # 先判断是否登录
  def auth_user
    unless user_signed_in?
      flash[:notice] = "请先登录"
      redirect_to new_user_session_path
    end
  end

  def fetch_home_data # 把公共动作抽象成方法
    @categories = Category.grouped_data
    # 取得当前购物车数量
    @shopping_cart_count = ShoppingCart.by_user_uuid(session[:user_uuid]).count
  end

  def set_browser_uuid
    # 用户第一次进来，uuid为nil
    uuid = cookies[:user_uuid]
    # 如果没有uuid
    unless uuid
      # 如果是登录状态，把当前用户的uuid赋值过去
      if user_signed_in?
        uuid = current_user.uuid
      else
        # 否则随机生成
        uuid = RandomCode.generate_utoken
      end
    end
    update_browser_uuid uuid
  end

  # 把uuid赋值给浏览器和session(购物车)
  def update_browser_uuid(uuid)
    session[:user_uuid] = cookies.permanent['user_uuid'] = uuid
  end
end

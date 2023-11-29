class PaymentsController < ApplicationController
  before_action :auth_user
  # 订单创建完毕后，会重定向到支付页面
  def index

  end
end

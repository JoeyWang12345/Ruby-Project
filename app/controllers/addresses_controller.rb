class AddressesController < ApplicationController
  layout false # 渲染不需要父模板视图
  before_action :auth_user # 保证用户已经登录
  before_action :find_address, only: [:edit, :update, :destroy, :set_default_address]

  # 送货地址的列表页面
  def index
    @addresses = current_user.addresses
  end

  def new
    @address = current_user.addresses.new
  end

  def create # 前端传递来的表单数据
    # 根据数据创建新的地址对象
    @address = current_user.addresses.new(address_params)
    if @address.save
      @addresses = current_user.reload.addresses
      # 返回一个json数据
      render json: {
        status: 'ok', # 后台处理成功
        data: render_to_string(template: 'addresses/index') # 把view模板路径放在data里，前端js中可以拿到后端渲染的html片段
      }
    else
      render json: {
        status: 'error',
        data: render_to_string(template: 'addresses/new')
        # data: render_to_string(template: 'addresses/new', locals: {address: @address})
      }
    end
  end

  def edit
    render action: :new
  end

  def update
    @address.attributes = address_params
    if @address.save
      @addresses = current_user.reload.addresses
      render json: {
        status: 'ok',
        data: render_to_string(template: 'addresses/index')
      }
    else
      render json: {
        status: 'error',
        data: render_to_string(template: 'addresses/new')
      }
    end
  end

  def destroy
    @address.destroy
    @addresses = current_user.addresses
    render json: {
      status: 'ok',
      data: render_to_string(template: 'addresses/index')
    }
  end

  # 把当前地址设为用户默认地址
  def set_default_address
    @address.set_as_default = 1
    @address.save

    @addresses = current_user.reload.addresses
    render json: {
      status: 'OK',
      data: render_to_string(template: 'addresses/index')
    }
  end

  private
  def address_params
    params.require(:address).permit(:contact_name, :cellphone, :address, :zipcode, :set_as_default)
  end

  def find_address
    @address = current_user.addresses.find(params[:id])
  end
end

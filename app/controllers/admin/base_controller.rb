class Admin::BaseController < ActionController::Base
  # 把这句话注释以后，不能形成页面，说明是有用的
  layout 'admin/layouts/admin' # 设置模板路径
end
class Users::Panel::BaseController < ApplicationController
  before_action :auth_user
end

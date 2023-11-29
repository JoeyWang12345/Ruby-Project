require "test_helper"

class Users::Panel::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_panel_orders_index_url
    assert_response :success
  end
end

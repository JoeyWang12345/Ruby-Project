require "test_helper"

class Users::Panel::AddressesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_panel_addresses_index_url
    assert_response :success
  end
end

require "test_helper"

class Users::Panel::ProfileControllerTest < ActionDispatch::IntegrationTest
  test "should get password" do
    get users_panel_profile_password_url
    assert_response :success
  end
end

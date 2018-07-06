require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_index_url
    assert_response :success
  end

  test "should get show" do
    get admins_show_url
    assert_response :success
  end

  test "should get password" do
    get admins_password_url
    assert_response :success
  end

  test "should get profile" do
    get admins_profile_url
    assert_response :success
  end

  test "should get two_factor_authentication" do
    get admins_two_factor_authentication_url
    assert_response :success
  end

  test "should get two_factor_authentication_setting" do
    get admins_two_factor_authentication_setting_url
    assert_response :success
  end

  test "should get update" do
    get admins_update_url
    assert_response :success
  end

end

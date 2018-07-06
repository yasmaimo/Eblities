require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_index_url
    assert_response :success
  end

  test "should get show" do
    get users_show_url
    assert_response :success
  end

  test "should get account" do
    get users_account_url
    assert_response :success
  end

  test "should get password" do
    get users_password_url
    assert_response :success
  end

  test "should get profile" do
    get users_profile_url
    assert_response :success
  end

  test "should get two_factor_authentication" do
    get users_two_factor_authentication_url
    assert_response :success
  end

  test "should get two_factor_authentication_setting" do
    get users_two_factor_authentication_setting_url
    assert_response :success
  end

  test "should get unsubscribe_confirm" do
    get users_unsubscribe_confirm_url
    assert_response :success
  end

  test "should get update" do
    get users_update_url
    assert_response :success
  end

end

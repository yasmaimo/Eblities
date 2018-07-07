require 'test_helper'

class KeepsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get keeps_index_url
    assert_response :success
  end

  test "should get create" do
    get keeps_create_url
    assert_response :success
  end

  test "should get update" do
    get keeps_update_url
    assert_response :success
  end

  test "should get destroy" do
    get keeps_destroy_url
    assert_response :success
  end

end

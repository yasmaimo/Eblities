require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get articles_index_url
    assert_response :success
  end

  test "should get user_timeline" do
    get articles_user_timeline_url
    assert_response :success
  end

  test "should get tag_timeline" do
    get articles_tag_timeline_url
    assert_response :success
  end

  test "should get show" do
    get articles_show_url
    assert_response :success
  end

  test "should get new" do
    get articles_new_url
    assert_response :success
  end

  test "should get confirm" do
    get articles_confirm_url
    assert_response :success
  end

  test "should get create" do
    get articles_create_url
    assert_response :success
  end

  test "should get edit" do
    get articles_edit_url
    assert_response :success
  end

  test "should get edit_confirm" do
    get articles_edit_confirm_url
    assert_response :success
  end

  test "should get update" do
    get articles_update_url
    assert_response :success
  end

end

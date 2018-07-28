class TaggingsController < ApplicationController

  before_action :authenticate_user

  def destroy
    tagging = Tagging.find(params[:id])
    @user = User.find(tagging.taggable_id)
    return if @user != current_user
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
    @new_tag = Tag.new
    @search_tag = Tag.ransack(params[:q])
    @tags = @search_tag.result.page(params[:page]).reverse_order
    @find_tag = Tag.find(tagging.tag_id)
    @tagging_articles = Tagging.where(tag_id: @find_tag.id, taggable_type: "Article")
    @tagging_users = Tagging.where(tag_id: @find_tag.id, taggable_type: "User")
    tagging.destroy
  end

end

class TagsController < ApplicationController

  def index
    @search_tag = Tag.ransack(params[:q])
    @tags = @search_tag.result.page(params[:page]).reverse_order
    if user_signed_in?
      @taggings = Tagging.where(taggable_type: "User", taggable_id: current_user.id)
    end
    @user = current_user
    @tag = Tag.new
  end

  def create
    params[:user][:tag_list].split(",").each do |tag_name|
      if Tag.exists?(name: tag_name)
        tag = Tag.find_by(name: tag_name)
        if Tagging.exists?(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id)
        else
          Tagging.create(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id, context: "tags")
        end
      else
        Tag.create(name: tag_name)
        tag = Tag.find_by(name: tag_name)
        Tagging.create(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id, context: "tags")
      end
    end
    @user = current_user
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
    @tag = Tag.new
    @search_tag = Tag.ransack(params[:q])
    @tags = @search_tag.result.page(params[:page]).reverse_order
  end

  def add
    tag_name = params[:user][:tag_list]
    if Tag.exists?(name: tag_name)
      tag = Tag.find_by(name: tag_name)
      if Tagging.exists?(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id)
      else
        Tagging.create(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id, context: "tags")
      end
    else
      Tag.create(name: tag_name)
      tag = Tag.find_by(name: tag_name)
      Tagging.create(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id, context: "tags")
    end
    @user = current_user
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
    @tag = Tag.new
    @search_tag = Tag.ransack(params[:q])
    @tags = @search_tag.result.page(params[:page]).reverse_order
    @find_tag = Tag.find_by(name: tag_name)
    @tagging_articles = Tagging.where(tag_id: @find_tag.id, taggable_type: "Article")
    @tagging_users = Tagging.where(tag_id: @find_tag.id, taggable_type: "User")
  end

  def show
    @user = current_user
    @tag = Tag.find(params[:id])
    @new_tag = Tag.new
    @search_tag_article = Article.tagged_with("#{@tag.name}").ransack(params[:q])
    @tag_articles = @search_tag_article.result.page(params[:page]).reverse_order
    @tagging_articles = Tagging.where(tag_id: params[:id], taggable_type: "Article")
    @tagging_users = Tagging.where(tag_id: params[:id], taggable_type: "User")
  end

  def update
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :taggings_count, :tag_list)
  end

end

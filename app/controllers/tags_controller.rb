class TagsController < ApplicationController

  def index
    @search_tag = Tag.ransack(params[:q])
    @tags = @search_tag.result.page(params[:page]).reverse_order
    if user_signed_in?
      @taggings = Tagging.where(taggable_type: "User", taggable_id: current_user.id)
    end
  end

  def create
    params[:user][:tag_list].split(",").each do |tag_name|
      if Tag.exists?(name: tag_name)
        @tag = Tag.find_by(name: tag_name)
        if Tagging.exists?(tag_id: @tag.id, taggable_type: "User", taggable_id: current_user.id)
        else
          Tagging.create(tag_id: @tag.id, taggable_type: "User", taggable_id: current_user.id, context: "tags")
          # count = @tag.taggings_count + 1
          # @tag.update(taggings_count: count)
        end
      else
        Tag.create(name: tag_name)
        @tag = Tag.find_by(name: tag_name)
        Tagging.create(tag_id: @tag.id, taggable_type: "User", taggable_id: current_user.id, context: "tags")
        # count = @tag.taggings_count + 1
        # @tag.update(taggings_count: count)
      end
    end
    redirect_to user_path(current_user)
  end

  def show
    @tag = Tag.find(params[:id])
    @search_tag_article = Article.tagged_with("#{@tag.name}").ransack(params[:q])
    @tag_article = @search_tag_article.result.page(params[:page]).reverse_order
    @taggings = Tagging.where(tag_id: params[:id], taggable_type: "Article")
  end

  def update
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :taggings_count, :tag_list)
  end

end

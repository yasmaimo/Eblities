class DraftsController < ApplicationController
  def index
    @user = current_user
    @tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: current_user.id)
    @search_draft = Draft.where(user_id: current_user.id).ransack(params[:q])
    @drafts = @search_draft.result.page(params[:page]).reverse_order
  end

  def confirm
    @draft = Draft.find(params[:id])
    @article = Article.new
  end

  def create_article
    @draft = Draft.find(params[:id])
    @article = Article.new(user_id: current_user.id, title: params[:article][:title], body: params[:article][:body], image_id: params[:article][:image_id])
    @article.tag_list.add(params[:article][:tag_list], parse: true)
    @article.save
    taggings = Tagging.where(taggable_type: "Article", taggable_id: @article.id)
    taggings.each do |tagging|
      count = tagging.tag.taggings_count
      count += 1
      tag = Tag.find(tagging.tag_id)
      tag.update(taggings_count: count)
    end
    add_five_point
    create_post
    redirect_to article_path(@article)
    @draft.destroy
  end

  def new
  end

  def edit
  end

  def show
    @draft = Draft.find(params[:id])
  end

  def update
    @draft = Draft.find(params[:id])
    @taggings = Tagging.where(taggable_type: "Draft", taggable_id: @draft.id)
    @taggings.destroy_all
    @draft.update(title: params[:draft][:title], body: params[:draft][:body])
    tagging_draft
    if params[:update_draft]
      redirect_to user_drafts_path(current_user)
    elsif params[:confirm_draft]
      redirect_to confirm_user_draft_path
    end
  end

  def destroy
  end

  private

  def create_post
    Post.create(
                user_id: @article.user_id,
                posted_by_id: current_user.id,
                article_id: @article.id,
                posted_type: "投稿")
  end

  def tagging_draft
    params[:draft][:tag_list].split(",").each do |tag_name|
      if Tag.exists?(name: tag_name)
        @tag = Tag.find_by(name: tag_name)
        if Tagging.exists?(tag_id: @tag.id, taggable_type: "Draft", taggable_id: @draft.id)
        else
          Tagging.create(tag_id: @tag.id, taggable_type: "Draft", taggable_id: @draft.id, context: "tags")
        end
      else
        Tag.create(name: tag_name)
        @tag = Tag.find_by(name: tag_name)
        Tagging.create(tag_id: @tag.id, taggable_type: "Draft", taggable_id: @draft.id, context: "tags")
      end
    end
  end

  def draft_params
    params.require(:draft).permit(:user_id, :title, :body, :tag_list)
  end

end

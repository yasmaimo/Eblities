class DraftsController < ApplicationController
  def index
    @user = current_user
    @tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: current_user.id)
    @drafts = Draft.where(user_id: current_user.id)
  end

  def confirm
    @draft = Draft.find(params[:id])
    @article = Article.new
  end

  def create_article
    @draft = Draft.find(params[:id])
    @article = Article.new(user_id: current_user.id, title: params[:article][:title], body: params[:article][:body])
    @article.tag_list.add(params[:article][:tag_list], parse: true)
    @article.save
    taggings = Tagging.where(taggable_type: "Article", taggable_id: @article.id)
    # taggings.each do |tagging|
    #   count = tagging.tag.taggings_count
    #   count += 1
    #   tag = Tag.find(tagging.tag_id)
    #   tag.update(taggings_count: count)
    # end
    get_ep_on_create
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
    @draft.update(draft_params)
    if params[:update_draft]
      redirect_to user_drafts_path(current_user)
    elsif params[:confirm_draft]
      redirect_to confirm_user_draft_path
    end
  end

  def destroy
  end

  private

  def draft_params
    params.require(:draft).permit(:user_id, :title, :body, :tag_list)
  end

end

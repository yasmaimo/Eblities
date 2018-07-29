class DraftsController < ApplicationController

  before_action :authenticate_user
  before_action :judge_user_id
  before_action :find_draft, only: [:confirm, :show, :update, :destroy]

  def index
    @user = current_user
    @new_tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: current_user.id)
    @search_draft = Draft.where(user_id: current_user.id).ransack(params[:q])
    @drafts = @search_draft.result.page(params[:page]).reverse_order
  end

  def confirm
    @article = Article.new
  end

  def update
    if params[:back]
      redirect_to user_draft_path(id: @draft) and return
    elsif params[:create_article]
      @article = Article.new(user_id: current_user.id, title: params[:draft][:title], body: params[:draft][:body], image: @draft.image)
      @article.tag_list.add(params[:draft][:tag_list], parse: true)
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
      flash[:article_created] = "記事を投稿しました"
      @draft.destroy and return
    end
    @draft.title = draft_params[:title]
    @draft.body = draft_params[:body]
    if @draft.invalid?
      flash.now[:invalid_article] = "入力内容を確認してください"
      render :show
      return
    end
    @taggings = Tagging.where(taggable_type: "Draft", taggable_id: @draft.id)
    @taggings.destroy_all
    @draft.update(title: params[:draft][:title], body: params[:draft][:body], image: params[:draft][:image])
    tagging_draft
    if params[:confirm_article]
      if @draft.invalid?
        redirect_to user_draft_path(id: @draft)
        flash[:invalid_article] = "入力内容を確認してください"
      elsif @draft.title.blank?
        redirect_to user_draft_path(id: @draft)
        flash[:invalid_article] = "記事を投稿する場合はタイトルを入力してください"
      elsif @draft.body.blank? || @draft.body == "<p><br></p>"
        redirect_to user_draft_path(id: @draft)
        flash[:invalid_article] = "記事を投稿する場合は本文を入力してください"
      else
        redirect_to confirm_user_draft_path
      end
    elsif params[:update_draft]
      redirect_to user_drafts_path(current_user)
      flash[:draft_created] = "下書きを保存しました"
    end
  end

  def destroy
    @draft.destroy
    redirect_to user_drafts_path(current_user)
    flash[:draft_deleted] = "下書きを削除しました"
  end





  private

  def judge_user_id
    unless params[:user_id].to_i == current_user.id
      redirect_to user_drafts_path(current_user)
    end
  end

  def find_draft
    if Draft.exists?(params[:id])
      @draft = Draft.find(params[:id])
    else
      redirect_to user_drafts_path(current_user)
    end
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

  def create_post
    Post.create(
                user_id: @article.user_id,
                posted_by_id: current_user.id,
                article_id: @article.id,
                posted_type: "投稿")
  end

  def draft_params
    params.require(:draft).permit(:user_id, :title, :body, :image ,:tag_list)
  end

end

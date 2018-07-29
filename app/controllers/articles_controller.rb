class ArticlesController < ApplicationController

  before_action :user_ranking
  before_action :tag_ranking
  before_action :authenticate_user, except: [:index, :show]
  before_action :find_article, only: [:edit, :show, :confirm_edit, :update, :destroy]
  before_action :judge_user_id, only: [:edit, :confirm_edit, :update, :destroy]

def index
  if user_signed_in?
    unless Notification.exists?(user_id: current_user.id, notified_type: "サインアップ")
      Notification.create(user_id: current_user.id, notified_type: "サインアップ")
    end
  end
  path = Rails.application.routes.recognize_path(request.referer)
end

  def user_timeline
    @search_post = Post.ransack(params[:q])
    @posts = @search_post.result.page(params[:page]).reverse_order
  end

  def confirm
    if params[:confirm_article]
      new_article
      if @article.invalid?
        flash[:invalid_article] = "入力内容を確認してください"
        render :new
      elsif @article.body == "<p><br></p>"
        flash[:invalid_article] = "本文を入力してください"
        render :new
      end
      flash[:invalid_article] = ""
    elsif params[:create_draft]
      create_draft
      redirect_to user_drafts_path(current_user)
      flash[:draft_created] = "下書きを保存しました"
    end
  end

  def create
    if params[:create_article]
      new_article
      @article.save
      add_five_point
      create_post
      redirect_to article_path(@article)
      flash[:article_created] = "記事を投稿しました"
    elsif params[:create_draft]
      create_draft
      redirect_to user_drafts_path(current_user)
      flash[:draft_created] = "下書きを保存しました"
    elsif params[:back]
      new_article
      render :new
    end
  end

  def new
    @article = Article.new
  end

  def edit
    @taggings = Tagging.where(taggable_type: "Article", taggable_id: @article.id)
  end

  def show
    @taggings = Tagging.where(taggable_type: "Article", taggable_id: @article.id)
    @user = User.find(@article.user_id)
    @comment = Comment.new
  end

  def update
    @article.tag_list.add(params[:article][:tag_list], parse: true)
    if params[:confirm_article]
      @article.title = article_params[:title]
      @article.body = article_params[:body]
      if @article.invalid?
        flash[:invalid_article] = "入力内容を確認してください"
        render :edit
      elsif @article.body == "<p><br></p>"
        flash[:invalid_article] = "本文を入力してください"
        render :edit
      else
        @article.update(article_params)
        redirect_to confirm_edit_path(@article)
      end
      flash[:invalid_article] = ""
    elsif params[:create_article]
      @article.update(article_params)
      redirect_to article_path(@article)
      flash[:article_created] = "記事を投稿しました"
    elsif params[:create_draft]
      @draft = Draft.new(user_id: current_user.id, title: article_params[:title], body: article_params[:body], image: @article.image)
      @draft.save
      tagging_draft
      @article.destroy
      redirect_to user_drafts_path(current_user)
      flash[:draft_created] = "下書きを保存しました"
    elsif params[:back]
      redirect_to edit_article_path(@article)
    end
  end

  def destroy
    destroy_post
    @article.destroy
    subtract_five_point
    redirect_to user_path(@article.user_id)
    flash[:article_deleted] = "記事を削除しました"
  end





  private

  def find_article
    if Article.exists?(params[:id])
      @article = Article.find(params[:id])
    else
      redirect_to root_path
    end
  end

  def judge_user_id
    unless @article.user_id == current_user.id
      redirect_to root_path(current_user)
    end
  end

  def user_ranking
    @users = User.all
  end

  def tag_ranking
    @tags = Tag.all
  end

  def new_article
    @article = Article.new( user_id: current_user.id,
                            title: article_params[:title],
                            body: article_params[:body],
                            image: article_params[:image],
                            tag_list: article_params[:tag_list] )
    @article.tag_list.add(article_params[:tag_list], parse: true)
  end

  def create_draft
    @draft = Draft.new(user_id: current_user.id, title: article_params[:title], body: article_params[:body], image: article_params[:image])
    @draft.save
    tagging_draft
  end

  def tagging_draft
    params[:article][:tag_list].split(",").each do |tag_name|
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

  def destroy_post
    post = Post.find_by(
                    user_id: @article.user_id,
                    posted_by_id: current_user.id,
                    article_id: @article.id,
                    posted_type: "投稿")
    post.destroy
  end

  def article_params
    params.require(:article).permit(:user_id, :title, :body, :image, :tag_list)
  end

end

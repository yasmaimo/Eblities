class ArticlesController < ApplicationController
  before_action :user_ranking
  before_action :tag_ranking
  before_action :authenticate_user, except: [:index, :show]

  def user_timeline
    @search_post = Post.ransack(params[:q])
    @posts = @search_post.result.page(params[:page]).reverse_order
  end

  def confirm
    if params[:confirm_article]
      @article = Article.new(
                            user_id: current_user.id,
                            title: article_params[:title],
                            body: article_params[:body],
                            image: article_params[:image],
                            tag_list: article_params[:tag_list])
      if @article.invalid?
        render :new
      end
    elsif params[:create_draft]
      @draft = Draft.new(user_id: current_user.id, title: article_params[:title], body: article_params[:body], image: article_params[:image])
      @draft.save
      tagging_draft
      redirect_to user_drafts_path(current_user)
    end
  end

  def create
    if params[:create_article]
      @article = Article.new(user_id: current_user.id, title: article_params[:title], body: article_params[:body], image: article_params[:image])
      @article.tag_list.add(article_params[:tag_list], parse: true)
      @article.save
      add_five_point
      create_post
      redirect_to article_path(@article)
    elsif params[:create_draft]
      @draft = Draft.new(user_id: current_user.id, title: article_params[:title], body: article_params[:body], image: article_params[:image])
      @draft.save
      tagging_draft
      redirect_to user_drafts_path(current_user)
    elsif params[:back]
      @article = Article.new(article_params)
      @article.tag_list.add(article_params[:tag_list], parse: true)
      render :new
    end
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
    @taggings = Tagging.where(taggable_type: "Article", taggable_id: @article.id)
  end

  def show
    @article = Article.find(params[:id])
    @user = User.find(@article.user_id)
    @user.id = @article.user_id
    @comment = Comment.new
    @taggings = Tagging.where(taggable_type: "Article", taggable_id: @article.id)
  end

  def confirm_edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.tag_list.add(params[:article][:tag_list], parse: true)
    if params[:confirm_article]
      @article.update(article_params)
      redirect_to confirm_edit_path(@article)
    elsif params[:create_article]
      @article.update(article_params)
      redirect_to article_path(@article)
    elsif params[:create_draft]
      @draft = Draft.new(user_id: current_user.id, title: article_params[:title], body: article_params[:body], image: @article.image)
      @draft.save
      tagging_draft
      @article.destroy
      redirect_to user_drafts_path(current_user)
    elsif params[:back]
      redirect_to edit_article_path(@article)
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    subtract_five_point
    redirect_to user_path(@article.user_id)
  end

  private

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

  def user_ranking
    @users = User.all
  end

  def tag_ranking
    @tags = Tag.all
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

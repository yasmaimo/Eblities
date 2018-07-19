class ArticlesController < ApplicationController
  before_action :user_ranking
  before_action :tag_ranking

  def index
  end

  def user_timeline
  end

  def tag_timeline
  end

  def confirm
    @article = Article.new(user_id: current_user.id, title: article_params[:title], body: article_params[:body])
    if @article.invalid?
      render :new
    end
  end

  def create
    if params[:create_article]
      @article = Article.new(user_id: current_user.id, title: article_params[:title], body: article_params[:body])
      @article.tag_list.add(article_params[:tag_list], parse: true)
      if @article.save
        get_ep_on_create
        post_timeline
      end
      redirect_to article_path(@article)
    elsif params[:create_draft]
      @draft = Draft.new(user_id: current_user.id, title: article_params[:title], body: article_params[:body])
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
  end

  def show
    @article = Article.find(params[:id])
    @user = User.find(@article.user_id)
    @user.id = @article.user_id
    @comment = Comment.new
    @taggings = Tagging.where(taggable_type: "Article", taggable_id: @article.id)
  end

  def edit_confirm
  end

  def update
    @article = Article.find(params[:id])
  end

  def user_ranking
    @users = User.all
  end

  def tag_ranking
    @tags = Tag.all
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

  private

  def post_timeline
    Post.create(
                user_id: current_user.id,
                post:
                "#{current_user.user_name}さんが新しい記事を投稿しました。
                【#{@article.title}】")
  end

  def article_params
    params.require(:article).permit(:user_id, :title, :body, :tag_list)
  end

end

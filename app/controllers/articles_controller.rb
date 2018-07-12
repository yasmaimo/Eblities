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
  end

  def create
    @article = Article.new(user_id: current_user.id, title: article_params[:title], body: article_params[:body])
    @article.tag_list.add(article_params[:tag_list], parse: true)
    if @article.save
      get_ep_on_create
    end
    redirect_to articles_path
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
  end

  def edit_confirm
  end

  def update
  end

  def user_ranking
    @users = User.order(:point).limit(10)
  end

  def tag_ranking
    @tags = ActsAsTaggableOn::Tag.most_used(10)
  end

  private

  def article_params
    params.require(:article).permit(:user_id, :title, :body, :tag_list)
  end

end

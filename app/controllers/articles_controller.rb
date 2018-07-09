class ArticlesController < ApplicationController
  def index
  end

  def user_timeline
  end

  def tag_timeline
  end

  def confirm
  end

  def create
    @article = Article.new(article_params)
    params[:article][:user_id] = 1.to_i
    @article.save
    redirect_to articles_path
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def show
  end

  def edit_confirm
  end

  def update
  end

  private

  def article_params
    params.require(:article).permit(:user_id, :title, :body)
  end

end

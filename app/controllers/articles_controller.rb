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
  end

  def new
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

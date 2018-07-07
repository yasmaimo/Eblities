class CommentsController < ApplicationController
  def index
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:article_id, :user_id, :comment)
  end

end

class CommentsController < ApplicationController
  def index
  end

  def create
    article = Article.find(params[:article_id])
    comment = current_user.comments.new(comment_params)
    comment.article_id = article.id
    if comment.save
      redirect_to article_path(article)
      flash[:succeeded] = "コメントを投稿しました"
    else
      redirect_to article_path(article)
      flash[:failed] = "500文字までのコメントを入力してください"
    end
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

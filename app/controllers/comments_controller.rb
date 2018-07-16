class CommentsController < ApplicationController
  def index
  end

  def create
    @article = Article.find(params[:article_id])
    @user = User.find(@article.user_id)
    @users = User.order(:point).limit(10)
    @taggings = Tagging.where(taggable_type: "Article")
    @comment = current_user.comments.new(comment_params)
    @comment.article_id = @article.id
    if @comment.invalid?
      render "articles/show", :locals => {:article => @article,
                                          :user => @user,
                                          :users => @users,
                                          :taggings => @taggings}
      return
      # flash[:failed] = "500文字までのコメントを入力してください"
    end
    if @comment.save
      redirect_to article_path(@article)
      flash[:succeeded] = "コメントを投稿しました"
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

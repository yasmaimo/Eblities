class CommentsController < ApplicationController

  before_action :authenticate_user

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
      flash.now[:comment_create_failed] = "500文字までのコメントを入力してください"
      render "articles/show", :locals => {:article => @article,
                                          :user => @user,
                                          :users => @users,
                                          :taggings => @taggings}
      return
    end
    if @comment.save
      create_notification
      create_post
      flash[:flash_message] = "コメントを投稿しました"
      redirect_to article_path(@article)
    end
  end

  def show
  end

  def update
  end

  def destroy
    @article = Article.find(params[:article_id])
    comment = Comment.find(params[:id])
    if comment.user_id != current_user.id
      redirect_to article_path(@article)
    else
      comment.destroy
      destroy_notification
      destroy_post
      flash[:flash_message] = "コメントを削除しました"
      redirect_to article_path(@article)
    end
  end





  private

  def create_post
    Post.create(
                user_id: @article.user_id,
                posted_by_id: current_user.id,
                article_id: @article.id,
                posted_type: "コメント")
  end

  def destroy_post
    post = Post.find_by(
                    user_id: @article.user_id,
                    posted_by_id: current_user.id,
                    article_id: @article.id,
                    posted_type: "コメント")
    post.destroy
  end

  def create_notification
    return if @article.user_id == current_user.id
    Notification.create(
                      user_id: @article.user_id,
                      notified_by_id: current_user.id,
                      article_id: @article.id,
                      notified_type: "コメント")
  end

  def destroy_notification
    notification = Notification.find_by(
                    user_id: @article.user_id,
                    notified_by_id: current_user.id,
                    article_id: @article.id,
                    notified_type: "コメント")
    notification.destroy
  end

  def comment_params
    params.require(:comment).permit(:article_id, :user_id, :comment)
  end

end

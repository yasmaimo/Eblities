class KeepsController < ApplicationController

  before_action :authenticate_user

  def index
    @search_keep = Keep.where(user_id: current_user.id).ransack(params[:q])
    @keeps = @search_keep.result.page(params[:page]).reverse_order
  end

  def create
    keep = current_user.keeps.new(article_id: params[:article_id])
    keep.save
    @article = Article.find(keep.article_id)
    @user = User.find(@article.user_id)
    add_five_point
    create_notification
    create_post
    flash.now[:flash_message] = "この記事を#{"キープ"}しました"
    @flash_message = flash.now[:flash_message]
  end

  def destroy
    keep = current_user.keeps.find_by(article_id: params[:article_id])
    keep.destroy
    @article = Article.find(params[:article_id])
    @user = User.find(@article.user_id)
    subtract_five_point
    destroy_notification
    destroy_post
    flash.now[:flash_message] = "この記事の#{"キープ"}を取り消しました"
    @flash_message = flash.now[:flash_message]
  end





  private

  def create_post
    Post.create(
                user_id: @article.user_id,
                posted_by_id: current_user.id,
                article_id: @article.id,
                posted_type: "キープ")
  end

  def destroy_post
    post = Post.find_by(
                    user_id: @article.user_id,
                    posted_by_id: current_user.id,
                    article_id: @article.id,
                    posted_type: "キープ")
    post.destroy
  end

  def create_notification
    return if @article.user_id == current_user.id
    Notification.create(
                      user_id: @article.user_id,
                      notified_by_id: current_user.id,
                      article_id: @article.id,
                      notified_type: "キープ")
  end

  def destroy_notification
    notification = Notification.find_by(
                    user_id: @article.user_id,
                    notified_by_id: current_user.id,
                    article_id: @article.id,
                    notified_type: "キープ")
    notification.destroy
  end

  def keep_params
    params.require(:keep).permit(:article_id, :user_id)
  end

end

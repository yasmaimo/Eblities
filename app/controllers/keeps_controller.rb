class KeepsController < ApplicationController

  def index
    @search_keep = Keep.where(user_id: current_user.id).ransack(params[:q])
    @keeps = @search_keep.result.page(params[:page]).reverse_order
  end

  def create
    path = Rails.application.routes.recognize_path(request.referer)
    keep = Keep.new(article_id: path[:id].to_i, user_id: current_user.id)
    keep.save
    @article = Article.find(keep.article_id)
    @user = User.find(@article.user_id)
    get_ep_one
    create_notifications
    redirect_to article_path(path[:id])
  end

  def update
  end

  def destroy
    @article = Article.find(params[:article_id])
    keep = current_user.keeps.find_by(article_id: params[:article_id])
    keep.destroy
    @user = User.find(@article.user_id)
    get_ep_on_release
    destroy_notifications
    redirect_to article_path(@article)
  end

  private

  def create_notifications
    return if @article.user_id == current_user.id
    Notification.create(
                      user_id: @article.user_id,
                      notified_by_id: current_user.id,
                      article_id: @article.id,
                      notified_type: "キープ")
  end

  def destroy_notifications
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

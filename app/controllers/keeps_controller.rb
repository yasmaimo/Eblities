class KeepsController < ApplicationController
  def index
    @search_keep = Keep.ransack(params[:q], user_id: current_user.id)
    @keeps = @search_keep.result.page(params[:page]).reverse_order
  end

  def create
    path = Rails.application.routes.recognize_path(request.referer)
    keep = Keep.new(article_id: path[:id].to_i, user_id: current_user.id)
    keep.save
    article = Article.find(keep.article_id)
    @user = User.find(article.user_id)
    get_ep_one
    redirect_to article_path(path[:id])
  end

  def update
  end

  def destroy
    article = Article.find(params[:article_id])
    keep = current_user.keeps.find_by(article_id: params[:article_id])
    keep.destroy
    @user = User.find(article.user_id)
    get_ep_on_release
    redirect_to article_path(article)
  end

  private

  def keep_params
    params.require(:keep).permit(:article_id, :user_id)
  end

end

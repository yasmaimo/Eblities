class KeepsController < ApplicationController
  def index
  end

  def create
    path = Rails.application.routes.recognize_path(request.referer)
    keep = Keep.new(article_id: path[:id].to_i, user_id: current_user.id)
    keep.save
    redirect_to article_path(path[:id])
  end

  def update
  end

  def destroy
    article = Article.find(params[:article_id])
    keep = current_user.keeps.find_by(article_id: params[:article_id])
    keep.destroy
    redirect_to article_path(article)
  end

  private

  def keep_params
    params.require(:keep).permit(:article_id, :user_id)
  end

end

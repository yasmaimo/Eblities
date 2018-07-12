class FavoritesController < ApplicationController
  def create
		article = Article.find(params[:article_id])
		favorite = current_user.favorites.new(article_id: article.id)
		favorite.save
		@user = User.find(article.user_id)
		get_ep_on_favorited
		redirect_to article_path(article)
  end

  def destroy
		article = Article.find(params[:article_id])
		favorite = current_user.favorites.find_by(article_id: params[:article_id])
		favorite.destroy
		@user = User.find(article.user_id)
		get_ep_on_release_favorite
		redirect_to article_path(article)
  end
end

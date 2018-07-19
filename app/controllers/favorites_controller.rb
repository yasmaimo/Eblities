class FavoritesController < ApplicationController

  def create
		@article = Article.find(params[:article_id])
		favorite = current_user.favorites.new(article_id: @article.id)
		favorite.save
		@user = User.find(@article.user_id)
		get_ep_one
		create_notifications
		redirect_to article_path(@article)
  end

  def destroy
		@article = Article.find(params[:article_id])
		favorite = current_user.favorites.find_by(article_id: params[:article_id])
		favorite.destroy
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
	                  notified_type: "イイね")
	end

	def destroy_notifications
		notification = Notification.find_by(
	                  user_id: @article.user_id,
	                  notified_by_id: current_user.id,
	                  article_id: @article.id,
	                  notified_type: "イイね")
		notification.destroy
	end

end

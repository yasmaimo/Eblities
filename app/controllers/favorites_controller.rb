class FavoritesController < ApplicationController

	before_action :return_user

  def create
		favorite = current_user.favorites.new(article_id: params[:article_id])
		favorite.save
		add_one_point
		create_notification
		create_post
    flash.now[:flash_message] = "この記事を#{"イイね"}しました"
    @flash_message = flash.now[:flash_message]
  end

  def destroy
		favorite = current_user.favorites.find_by(article_id: params[:article_id])
		favorite.destroy
		subtract_one_point
		destroy_notification
		destroy_post
    flash.now[:flash_message] = "この記事の#{"イイね"}を取り消しました"
    @flash_message = flash.now[:flash_message]
  end





	private

	def return_user
		if user_signed_in?
			@article = Article.find(params[:article_id])
			@user = User.find(@article.user_id)
			return if @article.user_id == current_user.id
		else
			return
		end
	end

  def create_post
    Post.create(
    						user_id: @article.user_id,
    						posted_by_id: current_user.id,
                article_id: @article.id,
                posted_type: "イイね")
  end

	def destroy_post
		post = Post.find_by(
	                  user_id: @article.user_id,
	                  posted_by_id: current_user.id,
	                  article_id: @article.id,
	                  posted_type: "イイね")
		post.destroy
	end

	def create_notification
		Notification.create(
		                  user_id: @article.user_id,
		                  notified_by_id: current_user.id,
		                  article_id: @article.id,
		                  notified_type: "イイね")
	end

	def destroy_notification
		notification = Notification.find_by(
	                  user_id: @article.user_id,
	                  notified_by_id: current_user.id,
	                  article_id: @article.id,
	                  notified_type: "イイね")
		notification.destroy
	end

end

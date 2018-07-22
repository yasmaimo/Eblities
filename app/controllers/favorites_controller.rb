class FavoritesController < ApplicationController

	before_action :return_user

  def create
		# @article = Article.find(params[:article_id])
		favorite = current_user.favorites.new(article_id: @article.id)
		favorite.save
		# @user = User.find(@article.user_id)
		add_one_point
		create_notification
		create_post
		redirect_to article_path(@article)
  end

  def destroy
		# @article = Article.find(params[:article_id])
		favorite = current_user.favorites.find_by(article_id: params[:article_id])
		favorite.destroy
		# @user = User.find(@article.user_id)
		subtract_one_point
		destroy_notification
		destroy_post
		redirect_to article_path(@article)
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
		# return if @article.user_id == current_user.id
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

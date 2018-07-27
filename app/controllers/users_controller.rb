class UsersController < ApplicationController
  def index
    @search_user = User.ransack(params[:q])
    @users = @search_user.result.page(params[:page]).reverse_order
  end

  def show
    @user = User.find(params[:id])
    @tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
    @search_user_article = Article.where(user_id: @user.id).ransack(params[:q])
    @user_articles = @search_user_article.result.page(params[:page]).reverse_order
  end

  def account
    @user = User.find(params[:id])
  end

  def password
    @user = User.find(params[:id])
  end

  def profile
    @user = User.find(params[:id])
  end

  def two_factor_authentication
    @user = User.find(params[:id])
  end

  def two_factor_authentication_setting
    @user = User.find(params[:id])
  end

  def confirm_unsubscribe
    @user = User.find(params[:id])
  end

  def unsubscribe
    @user = User.find(params[:id])
    status = params[:user][:status].to_i
    if status == 0
      redirect_to confirm_unsubscribe_path(current_user)
      flash[:failed] = "チェックを入れてください"
    elsif status == 1
      notifications = Notification.where(notified_by_id: @user.id)
      notifications.destroy_all
      @user.destroy
      redirect_to logout_path
      flash[:succeeded] = "退会処理が完了しました。ご利用ありがとうございました。"
    end
  end

  def update
    path = Rails.application.routes.recognize_path(request.referer)
    @user = User.find(params[:id])
    if @user.update(user_params)
      sign_in(@user, bypass: true)
      redirect_to action: path[:action]
      flash[:succeeded] = "変更を保存しました"
    else
      redirect_to action: path[:action]
      flash[:failed] = "6~16文字のパスワードを入力してください"
    end
  end

  def favorites
    @user  = User.find(params[:id])
    @search_favorite = @user.favorites.ransack(params[:q])
    @favorites = @search_favorite.result.page(params[:page]).reverse_order
    @tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
  end

  def comments
    @user  = User.find(params[:id])
    @search_comment = @user.comments.ransack(params[:q])
    @comments = @search_comment.result.page(params[:page]).reverse_order
    @tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
    @articles = Article.where(user_id: @user.id)
  end

  def followings
    @user  = User.find(params[:id])
    @search_following = @user.followings.ransack(params[:q])
    @followings = @search_following.result.page(params[:page]).reverse_order
    @tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
    @articles = Article.where(user_id: @user.id)
  end

  def followers
    @user  = User.find(params[:id])
    @search_user = @user.followers.ransack(params[:q])
    @users = @search_user.result.page(params[:page]).reverse_order
    @tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
    @articles = Article.where(user_id: @user.id)
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :introduction, :web_site_url, :image, :email, :password, :point, :status, :tag_list, :all_delete)
  end

end

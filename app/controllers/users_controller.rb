class UsersController < ApplicationController
  def index
    @search_user = User.ransack(params[:q])
    @users = @search_user.result.page(params[:page]).reverse_order
  end

  def show
    @user = User.find(params[:id])
    @tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: current_user.id)
    @articles = Article.where(user_id: current_user.id)
  end

  def account
  end

  def password
    @user = User.find(params[:id])
  end

  def profile
    @user = User.find(params[:id])
  end

  def two_factor_authentication
  end

  def two_factor_authentication_setting
    @user = User.find(params[:id])
  end

  def unsubscribe_confirm
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_profile_path(params[:id])
  end

  def following
    @user  = User.find(params[:id])
    @users = @user.followings
    render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers
    @tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: current_user.id)
    @articles = Article.where(user_id: current_user.id)
  end

  private

  def user_params
    params.require(:user).permit(:family_name, :given_name, :user_name, :introduction, :user_url, :image, :email, :password, :point, :status, :tag_list)
  end

end

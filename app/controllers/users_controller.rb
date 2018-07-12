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

  def unsubscribe_confirm
    @user = User.find(params[:id])
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
    params.require(:user).permit(:family_name, :given_name, :user_name, :introduction, :web_site_url, :image, :email, :password, :point, :status, :tag_list)
  end

end

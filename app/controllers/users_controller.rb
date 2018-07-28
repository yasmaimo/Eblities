class UsersController < ApplicationController

  before_action :authenticate_user, except: [:index, :show, :favorites, :comments, :followings, :followers]
  before_action :judge_user_id, except: [:index, :show, :favorites, :comments, :followings, :followers]
  before_action :find_user, except: [:index]
  before_action :find_tag_and_taggings, only: [:favorites, :comments, :followings, :followers]

  def index
    @search_user = User.ransack(params[:q])
    @users = @search_user.result.page(params[:page]).reverse_order
  end

  def show
    @new_tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
    @search_user_article = Article.where(user_id: @user.id).ransack(params[:q])
    @user_articles = @search_user_article.result.page(params[:page]).reverse_order
  end

  def update
    path = Rails.application.routes.recognize_path(request.referer)
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
    @search_favorite = @user.favorites.ransack(params[:q])
    @favorites = @search_favorite.result.page(params[:page]).reverse_order
  end

  def comments
    @search_comment = @user.comments.ransack(params[:q])
    @comments = @search_comment.result.page(params[:page]).reverse_order
  end

  def followings
    @search_following = @user.followings.ransack(params[:q])
    @followings = @search_following.result.page(params[:page]).reverse_order
  end

  def followers
    @search_user = @user.followers.ransack(params[:q])
    @users = @search_user.result.page(params[:page]).reverse_order
  end

  def unsubscribe
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




  private

  def judge_user_id
    unless params[:id].to_i == current_user.id
      redirect_to user_path(current_user)
    end
  end

  def find_user
    if User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      redirect_to user_path(current_user)
    end
  end

  def find_tag_and_taggings
    @new_tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
    @articles = Article.where(user_id: @user.id)
  end

  def user_params
    params.require(:user).permit(:user_name, :introduction, :web_site_url, :image, :email, :password, :point, :status, :tag_list)
  end

end

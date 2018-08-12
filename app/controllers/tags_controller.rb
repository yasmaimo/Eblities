class TagsController < ApplicationController

  before_action :authenticate_user, except: [:index, :show]
  before_action :set_user_info
  before_action :set_search_tag, only: [:index ,:create, :add]

  def index
    if user_signed_in?
      @taggings = Tagging.where(taggable_type: "User", taggable_id: current_user.id)
    end
  end

  def create
    if params[:user][:tag_list].blank?
      flash.now[:flash_message] = "14文字までのタグ名を入力してください" and return
    end
    params[:user][:tag_list].split(",").each do |tag_name|
      if Tag.new(name: tag_name).invalid?
        flash.now[:flash_message] = "14文字までのタグ名を入力してください" and return
      end
      if Tag.exists?(name: tag_name)
        tag = Tag.find_by(name: tag_name)
        unless Tagging.exists?(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id)
          Tagging.create(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id, context: "tags")
        end
      else
        Tag.create(name: tag_name)
        tag = Tag.find_by(name: tag_name)
        Tagging.create(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id, context: "tags")
      end
    end
    flash.now[:flash_message] = "タグリストを更新しました"
    @flash_message = flash.now[:flash_message]
  end

  def add
    tag_name = params[:user][:tag_list]
    if Tag.exists?(name: tag_name)
      tag = Tag.find_by(name: tag_name)
      unless Tagging.exists?(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id)
        Tagging.create(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id, context: "tags")
      end
    else
      Tag.create(name: tag_name)
      tag = Tag.find_by(name: tag_name)
      Tagging.create(tag_id: tag.id, taggable_type: "User", taggable_id: current_user.id, context: "tags")
    end
    @find_tag = Tag.find_by(name: tag_name)
    find_taggings
    flash.now[:flash_message] = "#{@find_tag.name}をあなたのタグリストに登録しました"
    @flash_message = flash.now[:flash_message]
  end

  def show
    if Tag.exists?(params[:id])
      @find_tag = Tag.find(params[:id])
      @search_tag_article = Article.tagged_with("#{@find_tag.name}").ransack(params[:q])
      @tag_articles = @search_tag_article.result.page(params[:page]).reverse_order
      find_taggings
    else
      redirect_to tags_path
    end
  end





  private

  def set_user_info
    if user_signed_in?
      @user = current_user
      @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
      @new_tag = Tag.new
    end
  end

  def find_taggings
    @tagging_articles = Tagging.where(tag_id: @find_tag.id, taggable_type: "Article")
    @tagging_users = Tagging.where(tag_id: @find_tag, taggable_type: "User")
  end

  def set_search_tag
    @search_tag = Tag.ransack(params[:q])
    @tags = @search_tag.result.page(params[:page]).reverse_order
  end

  def tag_params
    params.require(:tag).permit(:name, :taggings_count, :tag_list)
  end

end

class KeepsController < ApplicationController
  def index
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def keep_params
    params.require(:keep).permit(:article_id, :user_id)
  end

end

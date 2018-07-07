class DraftsController < ApplicationController
  def index
  end

  def confirm
  end

  def create
  end

  def new
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def draft_params
    params.require(:draft).permit(:user_id, :title, :body)
  end

end

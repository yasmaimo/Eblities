class ImagesController < ApplicationController
  def create
  	@image = Image.new(image_params)
  	@image.save

  	respond_to do |format|
  		format.json { render :json => { url: Refile.attachment_url(@image, :image)}}
  	end
  end

  def destroy
  end

  private

  def image_params
  	params.require(:image).permit(:article_id, :image)
  end

end

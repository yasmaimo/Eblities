class ImagesController < ApplicationController
  def create
    @image = Image.new(params.require(:image).permit(:image))
    @image.post_id = 1
    @image.post_type = "Draft"
    if @image.save
      render json: {url: @image.url("280x210")}, status: 200
    else
      render nothing: true, status: 500
    end
  end

  def destroy
  end

  private

  def image_params
  	params.require(:image).permit(:post_id, :post_type, :image)
  end

end

# frozen_string_literal: true

class PhotosController < ApplicationController
  def index
    @photo = Photo.all
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      redirect_to organizations_show_path, notice: 'Successfully uploaded.'
    else
      render 'new'
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to organizations_show_path, notice: 'Successfully deleted.'
  end

  private

  def photo_params
    params.require(:photo).permit(:name, :attachment)
  end
end

class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :check_subscription

  def index
    @photos = Photo.all.order(created_at: :desc)
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      redirect_to photos_path, notice: 'Foto enviada com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def check_subscription
    unless current_user.subscribed?
      redirect_to root_path,alert: 'Você precisa assinar um plano para acessar.'
    end
  end

  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
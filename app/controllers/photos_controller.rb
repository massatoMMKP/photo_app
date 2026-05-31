class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :check_subscription

  def index
  end

  def new
  end

  def create
  end

  private

  def check_subscription
    unless current_user.subscribed?
      redirect_to root_path, alert: 'Você precisa assinar um plano para acessar.'
    end
  end
end

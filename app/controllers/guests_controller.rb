class GuestsController < ApplicationController

  before_action :authenticate_user!

  def index
    @guests = Guest.all
  end

  def create
    @guest = Guest.create(guest_params)

    if @guest.save
      render json: @guest
    else
      render json: @guest.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @guest = Guest.find(params[:id])
    @guest.destroy
    head :no_content
  end

  def update
    @guest = Guest.find(params[:id])
    if @guest.update(guest_params)
      render json: @guest
    else
      render json: @guest.errors, status: :unprocessable_entity
    end
  end

  private

    def guest_params
      params.require(:guest).permit(:first_name, :last_name)
    end

end

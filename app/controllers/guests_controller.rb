class GuestsController < ApplicationController
  before_filter :verify_is_admin
  before_action :authenticate_user!
  
	def index
    @guests = User.all
    @entrees = Entree.all
    @entrees.unshift(Entree.new(:name => "None", :description => "Choose an entree", :id => -1))
    @attending_count = count_guests 
  end

  def count_guests
    # Count attending guests plus their plus-ones (avoid double-counting)
    User.where(:attending => true).count + User.where(:plusone => true, :attending => true).count
  end

  def count
    render json: count_guests
  end

  def export
    attending_users = User.where(:attending => true)
    respond_to do |format|
      format.csv {send_data User.to_csv(attending_users), filename: "guests-#{Date.today}.csv"}
    end
  end

  def create
    @guest = User.create(guest_params)

    if @guest.save
      render json: @guest
    else
      render json: @guest.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @guest = User.find(params[:id])
    @guest.destroy
    head :no_content
  end

  def update
    @guest = User.find(params[:id])
    if @guest.update(guest_params)
      render json: @guest
    else
      render json: @guest.errors, status: :unprocessable_entity
    end
  end

  private

    def guest_params
      params.require(:guest).permit(:password, :first_name, :last_name, :email, :admin, :attending, :plusone, :first_name, :last_name, :address1, :address2, :zipcode, :city, :state, :state, :country, :username, :plus_one_first_name, :plus_one_last_name, :entree_id, :plus_one_entree_id, :rsvp_edit_dateline, :can_bring_plus_one)
    end

	  def verify_is_admin
	    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
	  end


end

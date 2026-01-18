class UsersController < ApplicationController

  before_action :authenticate_user!

	def update
   @user = User.find(params[:id])
	 @user.update_attributes(user_params)			
	 respond_to do |format|
    if @user.save						
						format.json {render :json => @user}
		end
	 end
	end

	private

	def user_params
					params.require(:user).permit(:email, :attending, :plusone, :plus_one_first_name, :plus_one_last_name, :entree_id, :plus_one_entree_id)
	end
end


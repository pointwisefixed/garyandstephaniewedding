class AdminController < ApplicationController

  before_filter :verify_is_admin

  def index
    @weddingInfo = WeddingInfo.all[0]
    if @weddingInfo.nil?
      @weddingInfo = WeddingInfo.new
      @weddingInfo.save
    end
    @weddingInfo
  end

  def update
    @weddingInfo = WeddingInfo.find(params[:id])
    if @weddingInfo.update(wedding_info_params)
      render json: @weddingInfo
    else
      render json: @weddingInfo.errors, status: :unprocessable_entity
    end
 
  end


  private
	  def verify_is_admin
	    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
	  end

	  def wedding_info_params
	    params.require(:weddingInfo).permit(:hisInformation,:herInformation,:ourStory,:ourFirstMeeting,:ourFirstMeeting,:ourFirstDate,:proposal,:theRing,:whenAndWhereIsTheWedding,:ceremony,:reception,:accomodations,:attending,:ourGallery,:dontMissIt,:moreEvents,:dancingParty,:flowerAndFlowers,:groomsmen,:bestFriend,:bridesmaid,:maidOfHonor,:bestMan,:bestBrideFriend,:giftRegistry,:rsvpInfo)	  
	  end

end

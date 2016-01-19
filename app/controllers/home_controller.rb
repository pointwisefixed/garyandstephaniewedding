class HomeController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #
  before_action :authenticate_user!

  def index
    @weddingInfo = WeddingInfo.all[0]
		if @weddingInfo.nil?
      @weddingInfo = WeddingInfo.create
		end
		@weddingInfo
		@entrees = Entree.all
  end

end

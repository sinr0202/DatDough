class HomeController < ApplicationController
	
  def index
    @wide = true
  end

  def check
  	if user_signed_in?
  		render json: {session: true, user: current_user}, status: :ok
  	else
  		render json: {session: false}, status: :ok
  	end
  end

end

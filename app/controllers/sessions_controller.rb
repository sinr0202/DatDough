class SessionsController < Devise::SessionsController  
	skip_before_filter :verify_authenticity_token
	clear_respond_to
	layout false
    respond_to :json
end  
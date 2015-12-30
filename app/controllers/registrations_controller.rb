class RegistrationsController < Devise::RegistrationsController  
	clear_respond_to
	layout false
    respond_to :json
end  
class PasswordsController < Devise::PasswordsController

	before_action :check_domain, only: [:create]

  def create
    
	logger.debug "My Controller"
	
	# params.require(:user).permit(:email)
	
	tmp_user = User.where("email = ?",params[:user][:email]).first
	
	if tmp_user.nil?
	
	   logger.debug "Does not exist, so create"
	   
	   tmp_user = User.new(params.require(:user).permit(:email))
	   #tmp_user.accepted = false
	   tmp_user.password = "********"
	   
	   logger.debug tmp_user
	   
	   if tmp_user.save!
	   
	       logger.debug "New user created"
		   
		   super
		   
	   else
	   
	       logger.debug "Could not create user"
		   
	   end
	
	else
	
	   logger.debug "Does exist, send email to login"
	   
	   super
	   
	end
	
  end
  
  def edit
  
    token=params[:reset_password_token]
	
	#new_parameters = Hash.new
	
	#new_parameters[:user][:reset_password_token]=token
	#new_parameters[:user][:password]="********"
	#new_parameters[:user][:password_confirmation]="********"
  
    #update(new_parameters)
	
	#redirect_to root
  
     # super
	 @newparams = {}
	 @newparams = {"reset_password_token" => token, "password" => "********", "password_confirmation" => "********"} 
	 logger.debug @newparams.to_s
	 
	 self.resource = resource_class.reset_password_by_token ( {
				:reset_password_token => token,
				:password => 'new_password',
				:password_confirmation => 'new_password' } )
	 
	 logger.debug self.resource.to_s
	 
	yield resource if block_given?
	if resource.errors.empty?
		resource.unlock_access! if unlockable?(resource)
		flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
		set_flash_message(:notice, flash_message) if is_flashing_format?
		sign_in(resource_name, resource)
		#respond_with resource, location: users_path #after_resetting_password_path_for(resource)
		
		redirect_to templates_path

		logger.debug "All OK"

	else
		# respond_with resource
		redirect_to root_path
		logger.debug "All NOT OK"

	end
	 #redirect_to users_path
	 
	 #update 
	 
	 
  end
  
  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    return "/waitforinstructions.html"
  end

  private
  def check_domain

  	if params[:user][:email] =~ /#{Rails.configuration.loginval}/

  		return true

  	else

  		redirect_to root_path

  	end


  end
  
  
  
end
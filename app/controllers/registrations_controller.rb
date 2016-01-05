class RegistrationsController < Devise::RegistrationsController

   skip_before_filter :require_no_authentication, :only => [:create]
   
   def create
   
       tmp_user = User.where("email = ?",params[:user][:email]).first
	
	   if tmp_user.nil?
	
		   logger.debug "Does not exist, so create"
		   
		   tmp_user = User.new(params.require(:user).permit(:email))
		   tmp_user.accepted = false
		   tmp_user.password = "********"
		   tmp_user.audit_comment = "User " + params[:user][:email] + " created"
		   
		   logger.debug tmp_user
		   
		   if tmp_user.save!
		   
			   logger.debug "New user created"
			   
		   else
		   
			   logger.debug "Could not create user"
			   
		   end
	   
	   end
	   
	   redirect_to users_path
	   
	   
    end


end
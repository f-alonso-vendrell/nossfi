class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :read_allowed_or_authenticate!

  before_filter :set_cache_buster

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  private

  def read_allowed_or_authenticate!
    logger.info "read_allowed_or_authenticate!"

    if Rails.configuration.allow_read_unauthenticated 
      logger.info "read is allowd for unauthenticated"
      if request.get?

        return true

      else

        authenticate_user!

      end

    else
      authenticate_user!
    end
  end
  
end

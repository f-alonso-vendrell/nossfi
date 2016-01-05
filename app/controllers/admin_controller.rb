class AdminController < ApplicationController
  before_filter :validate_admin_user

   # GET /admin
  def edit

    @admin = Admin.all.first

    if @admin.nil?

      @admin=Admin.new
      @admin.data="{email_writting: "+Rails.configuration.admin_email+"}"
      @admin.save


    end

  end

  
  # PATCH/PUT /admin
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def validate_admin_user

      # Rails.configuration.each do |conf|

      #   logger.info "CONF "+conf

      # end

      if (current_user.email != Rails.configuration.admin_email)

        logger.info "CURRENT USER IS: "+current_user.email
        
          redirect_to "/"
        end

    end

  end

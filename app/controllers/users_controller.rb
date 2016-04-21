class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :validate_user, only: [:update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    @user.initPrefs

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      
      prefs = @user.getPreferencesFor(params[:user][:pref_template])

      if prefs.nil?

        prefs = Hash.new

      end

      if ! params[:user][:pref_show].nil?

        # prefs["show"]= params[:user][:pref_show]

        @user.addShowFor(params[:user][:pref_template],params[:user][:pref_show])

      elsif ! params[:user][:pref_hide].nil?

        # prefs["hide"]= params[:user][:pref_hide]

        @user.addHideFor(params[:user][:pref_template],params[:user][:pref_hide])

      end

      # @user.setPreferencesFor(params[:user][:pref_template],prefs)

      logger.debug "User UPDATE CAlled"

      @user.save

      #if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      #else
      #  format.html { render action: 'edit' }
      #  format.json { render json: @user.errors, status: :unprocessable_entity }
      #end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email,:pref_template,:pref_show,:pref_hide)
    end

    def validate_user

      if @user.id != current_user.id 

        redirect_to root_path

      end


    end




end

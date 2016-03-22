class GroupersController < ApplicationController
  before_action :set_grouper, only: [:show, :edit, :update, :destroy]

  # GET /groupers
  # GET /groupers.json
  def index

     if ! params["template_id"].nil?

      @template = Template.find(params["template_id"])

      if ! @template.nil?

         @groupers= Grouper.where("template = ?",params["template_id"])

      end

    end

    if @groupers.nil?

      @groupers = Grouper.all

    end

  end

  # GET /groupers/1
  # GET /groupers/1.json
  def show

    

  end

  # GET /groupers/new
  def new

    if params["template_id"].nil?

      redirect_to templates_url

    else

      @template = Template.find(params["template_id"])

      if @template.nil?

        redirect_to templates_url

      end

      @grouper = Grouper.new

      @fields = @template.getFieldsNames;

      @grouper.template = @template.id

    end

  end

  # GET /groupers/1/edit
  def edit
    template=Template.find(@grouper.template)

    @fields = template.getFieldsNames;
  end

  def validateCode

    # TEMPLATE.select(FIELDS).where(CONDITION)

    # Validate TEMPLATE exists

    # Validate FIELDS exist for TEMPLATE, validate unique

    # Validate CONDITION, Boolean syntax, or, and, not, ==, <,>,<=,>=,!=,.contains
    # template fields
    # Reserved items: TODAY, MYSELF


  end

  # POST /groupers
  # POST /groupers.json
  def create
    @grouper = Grouper.new(grouper_params)
    
    respond_to do |format|
      if @grouper.save
        format.html { redirect_to groupers_path(:template_id => @grouper.template), notice: 'Grouper was successfully created.' }
        format.json { render action: 'show', status: :created, location: @grouper }
      else
        format.html { render action: 'new' }
        format.json { render json: @grouper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groupers/1
  # PATCH/PUT /groupers/1.json
  def update
    respond_to do |format|
      if @grouper.update(grouper_params)
        format.html { redirect_to @grouper, notice: 'Grouper was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @grouper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groupers/1
  # DELETE /groupers/1.json
  def destroy
    @grouper.destroy
    respond_to do |format|
      format.html { redirect_to groupers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grouper
      @grouper = Grouper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grouper_params
      params.require(:grouper).permit(:template, :name, :code)
    end
end

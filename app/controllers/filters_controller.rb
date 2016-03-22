class FiltersController < ApplicationController
  before_action :set_filter, only: [:show, :edit, :update, :destroy]

  # GET /filters
  # GET /filters.json
  def index

     if ! params["template_id"].nil?

      @template = Template.find(params["template_id"])

      if ! @template.nil?

         @filters= Filter.where("template = ?",params["template_id"])

      end

    end

    if @filters.nil?

      @filters = Filter.all

    end

  end

  # GET /filters/1
  # GET /filters/1.json
  def show

    

  end

  # GET /filters/new
  def new

    if params["template_id"].nil?

      redirect_to templates_url

    else

      @template = Template.find(params["template_id"])

      if @template.nil?

        redirect_to templates_url

      end

      @filter = Filter.new

      @fields = @template.getFieldsNames;

      @filter.template = @template.id

    end

  end

  # GET /filters/1/edit
  def edit
    template=Template.find(@filter.template)

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

  # POST /filters
  # POST /filters.json
  def create
    @filter = Filter.new(filter_params)
    
    respond_to do |format|
      if @filter.save
        format.html { redirect_to filters_path(:template_id => @filter.template), notice: 'Filter was successfully created.' }
        format.json { render action: 'show', status: :created, location: @filter }
      else
        format.html { render action: 'new' }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /filters/1
  # PATCH/PUT /filters/1.json
  def update
    respond_to do |format|
      if @filter.update(filter_params)
        format.html { redirect_to @filter, notice: 'Filter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.json
  def destroy
    @filter.destroy
    respond_to do |format|
      format.html { redirect_to filters_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filter
      @filter = Filter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def filter_params
      params.require(:filter).permit(:template, :name, :code)
    end
end

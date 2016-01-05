class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # GET /templates
  # GET /templates.json
  def index
    @templates = Template.all

     


    @templates.each do |template|

      if template.templateVersion.nil?

        logger.info "NIL VERSION: " + template.id.to_s
      else
         logger.info "VERSION: " + template.templateVersion.to_s
    end

      template.fields = template.getFieldsNames.join(",");


    end
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new

    @template = Template.new
    @template.templateVersion=1
    @template.aprovable = "false"
    @template.acknowledgeable ="false"
    if ! params["template_id"].nil?

       @template_based=Template.find(params[:template_id])

       @template.title = @template_based.title
       @template.desc = @template_based.desc
       @template.fields = @template_based.fields
       @template.aprovable = @template_based.aprovable
       @template.acknowledgeable = @template_based.acknowledgeable
       @template.defaultemail = @template_based.defaultemail

     elsif ! params["parent_id"].nil?

       @template_based=Template.find(params[:parent_id])

       @template.title = @template_based.title
       @template.desc = @template_based.desc
       @template.templateVersion = getLastVersion(@template_based) + 1
       @template.fields = @template_based.fields
       @template.aprovable = @template_based.aprovable
       @template.acknowledgeable = @template_based.acknowledgeable
       @template.defaultemail = @template_based.defaultemail
       @template.parent = params[:parent_id]
   
     end
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)
    @template.templateVersion = 1



    if ! @template.parent.nil?

      # TODO: this was in case of tree now versions are linear
      @parent = Template.find(@template.parent)
      if @parent.childtemplates.nil?
        @parent.childtemplates = 1
      else
        @parent.childtemplates =  @parent.childtemplates+1
      end
      @parent.save

      if ! @parent.templateVersion.nil?

        @template.templateVersion = @parent.templateVersion+1

      end


    end

    @template.creator = current_user.id

    logger.info "CREATING VERSION: " + @template.templateVersion.to_s

    # @template = Template.new()
    # @template.templateVersion=50
    # @template.title="dssdf"
    # @template.desc="sdfdsf"
    # @template.defaultemail="asdads"
    # @template.fields="sdfsdfsdf"
    
      
    


    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: 'Template was successfully created.' }
        format.json { render action: 'show', status: :created, location: @template }
      else
        format.html { render action: 'new' }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
     
      #@template.creator = current_user.id
      if @template.update(template_params)
        @template.creator=current_user.id
        @template.save
        format.html { redirect_to @template, notice: 'Template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy

    #@forms_ref = Form.where("template_id = ?",@template.id)

    if (! @template.isUsed)

      @template.destroy
      respond_to do |format|
        format.html { redirect_to templates_url }
        format.json { head :no_content }
      end

     else
         # @template = Template.new

         @template.errors.add(:childforms, "template being used")

        respond_to do |format|
          index()
          format.html { render action: 'index'}
          format.json { head :no_content }
        end



     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:title, :desc, :creator, :templateVersion, :fields, :aprovable, :acknowledgeable, :defaultemail, :parent)
    end

    # return version 1 (template) of a thread of templates
    def getFirstVersion(template)

      parent = template

      until parent.parent.nil?
        parent_tmp = Template.where("id = ?",parent.parent)
        if ! parent_tmp.nil?
          parent=parent_tmp
        else
          return parent
        end
      end

      return parent

    end

    # return the last version (number) being used for a thread of templates
    def getLastVersion(template)

      parent = template
      child_tmp = Template.where("parent = ?",parent.id).first

      until child_tmp.nil?
        parent = child_tmp
        child_tmp = Template.where("parent = ?",parent.id).first
      end

      return parent.templateVersion

    end
end

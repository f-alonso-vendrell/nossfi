class FormsController < ApplicationController
  before_action :set_form, only: [:show]
  before_action :set_delete_forms, only: [:destroy]
  before_action :set_edit_forms, only: [:edit]
  before_action :set_update_forms, only: [:update]

  class Notification
      attr_accessor :id, :recipients, :act, :from
  end


  # GET /forms
  # GET /forms.json
  def index

    @duration = 60

    if ! params["duration"].nil?

      @duration = params["duration"].to_i

    end

    @related_to_me = false

    if ! params["related_to_me"].nil? and params["related_to_me"] == "t"

      @related_to_me = true

    end


    

    if ! params["template_id"].nil?

      @template = Template.find(params["template_id"])

      if ! @template.nil?

        #if @related_to_me

         # @forms = Form.where("template_id = ? and updated_at >= ? and ( data like ? or creator = ? )",@template.id,
          #                    Date.today-@duration,
           #                   "%"+current_user.email+"%",
            #                  current_user.id)

        # else

          # @forms = Form.where("template_id = ? and updated_at >= ?",@template.id,Date.today-@duration)

         #end

         @filters= Filter.where("template = ?",params["template_id"])

         if ! params["filter"].nil?
           @cur_filter= Filter.where("id = ?",params["filter"]).first
           if @cur_filter.nil?
            @cur_filter=@filters.first
           end
         else
          @cur_filter=@filters.first

        end

        @forms=[]

        if @cur_filter.nil?

          @forms = Form.where("template_id = ? and updated_at >= ?",@template.id,Date.today-@duration)

        else

          forms_tmp = Form.where("template_id = ?",@template.id)

          code=@cur_filter.code
          form_json=forms_tmp.first.as_json
          logger.info "DATA AS JSON: "+form_json.keys.to_s
          form_data_json = ActiveSupport::JSON.decode(form_json["data"])
          logger.info "DATA AS JSON: "+form_data_json.keys.to_s
          prepared_code = prepare_filter_code(code,form_json,form_data_json)
          

          forms_tmp.each do |form|

            

            result=false
            result.taint



            th = Thread.new {

              form_json=form.as_json
              form_json.taint


              

              form_data_json = ActiveSupport::JSON.decode(form_json["data"])
              form_data_json.taint

              




              $SAFE = 4

              

              

              eval(prepared_code)

              

            }
            th.join

            if result

              @forms << form

            end

          end




        end



        respond_to do |format|
          format.html { render action: 'index_simple.html'}
          format.json 
        end

        #if params[:format] == "json"

          # render action: 'index.json' 

        #else
           
          
        #end

      end

    else

      @forms = Form.all

    end


    
  end

  # GET /forms/1
  # GET /forms/1.json
  def show

    @data=@form.data

  end

  # GET /forms/new
  def new
    @form = Form.new

    if params["template_id"].nil?

      redirect_to templates_url

    end

    begin

      template = Template.find(params["template_id"])

      @form.template = template

      @form.recipients = template.defaultemail

      @fields = template.getFields;

      @data = @form.data

    rescue ActiveRecord::RecordNotFound => e
      
    end

  end

  # GET /forms/1/edit
  def edit

       @fields = @forms.first.template.getFieldsNames

       @template = @forms.first.template

       @form = Form.new

       # @data = Hash[fields.each_with_object(nil).to_a]


  end

  def relate

    @form = Form.new

    @template = Template.new

    @action = "ACTION"

    extra_data = ""

    if params[:op_type] == "ack"

      @action = "Acknowledge"

      begin

         @template = Template.find(3)

        
        @fields = @template.getFields;

        
          rescue ActiveRecord::RecordNotFound => e

          end

          extra_data=""


    end


    data=params[:op_form_data]
    data=data.tr('{','')
    data=data.tr('}','')

    ids = data.split(",")

    @forms = []

    ids.each do |form_id|

        related = Form.where("id = ?",form_id)

        form = Form.new
        form.template_id = @template.id
        form.recipients = "TODO" # related.creator
        form.data=form_id.to_s+extra_data

        

        @forms<<form
    end





  end

  # POST /forms
  # POST /forms.json
  def create

    @template = Template.find(params[:create_form_template_id])

    forms = getForms()

    

    myerrors = []
    notifications = []

    errorspresent=false

    if forms.length == 0

      errorspresent=true

    end

 

    forms.each do |form|

        #data=form.split("{")
        #recipients = data.last
        #data.pop
        #new_data=data.join("{")
        #recipients=form["Notification emails"]
        #form.except!("Notification emails")


      

        @form = Form.new()
        @form.template_id = @template.id
        @form.creator = current_user.id
        #@form.recipients = recipients
        @form.private = false
        @form.data = form.to_json

     # if validate(@form)

        if ! @form.save
          logger.info "ERROR SAVING FORM"+form
          myerrors << "Error with "+form
          errorspresent=true
        else
          notification = Notification.new
          notification.id = @form.id
          #notification.recipients = recipients
          notification.act = "created"
          notification.from = current_user.email
          notifications << notification
        end
      #else
      #  logger.info "ERROR VALIDATING FORM"+form
      #  myerrors << "Error with "+form
      #  errorspresent=true
      # end

    end

    notifications.each do |notif|

      UserMailer.notification_email(notif).deliver!

    end

    if (errorspresent)
      logger.info "ERROR PRESENT"
      redirect_to :back

    else
       redirect_to :controller => 'forms', :action => 'index', :template_id => @template.id, notice: 'Forms were successfully created.'
    end


  end


  def do_op

    #TODO
    redirect_to forms_url


  end



  # PATCH/PUT /forms/1
  # PATCH/PUT /forms/1.json
  def update

    if @forms.length == 0

      errorspresent=true

    end

    myerrors = []
    notifications = []
    
    @forms.each do |form|

      
      logger.info "about to update"+form.data
        

      #if validate(form)

        form.creator = current_user.id

        if ! form.save
          logger.info "ERROR SAVING FORM"+form.data
          myerrors << "Error with "+form.data
          errorspresent=true
        else
          notification = Notification.new
          notification.id = form.id
          notification.recipients = form.recipients
          notification.act = "updated"
          notification.from = current_user.email
          notifications << notification
        end
      #else
      #  logger.info "ERROR VALIDATING FORM"+form.data
      #  myerrors << "Error with "+form.data
      #  errorspresent=true
      #end

    end

    notifications.each do |notif|

      # UserMailer.notification_email(notif).deliver!

    end

    if (errorspresent)
      logger.info "ERROR PRESENT"
      redirect_to :back

    else
       redirect_to :controller => 'forms', :action => 'index', :template_id => @template.id, notice: 'Forms were successfully created.'
    end




  end

  # DELETE /forms/1
  # DELETE /forms/1.json
  def destroy
    # dont do anything yet... @form.destroy

    template_id = @forms.first.template_id

    notifications = []

    @forms.each do |form|

      logger.info "destroying"+form.id.to_s

      notification = Notification.new
          notification.id = form.id
          notification.recipients = form.recipients
          notification.act = "deleted"
          notification.from = current_user.email
          notifications << notification

      form.destroy

    end

    notifications.each do |notif|

      UserMailer.notification_email(notif).deliver!

    end

    respond_to do |format|
      format.html { redirect_to :controller => 'forms', :action => 'index',:template_id => template_id }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    def prepare_filter_code(code,form_json,form_data_json)

      logger.info "DATA AS JSON: "+form_json.keys.to_s
      logger.info "DATA AS JSON: "+form_data_json.keys.to_s

      code_tmp=code

      form_json.keys.each do |subs|

        code_tmp=code_tmp.gsub("."+subs,"form_json['"+subs+"']") 

      end

      logger.info "FILTER NOW IS"+code_tmp

      form_data_json.keys.each do |subs|

        code_tmp=code_tmp.gsub("."+subs,"form_data_json['"+subs+"']") 

      end

      code_tmp = code_tmp.gsub("myself",current_user.id.to_s)

      logger.info "FILTER NOW IS"+code_tmp

      return code_tmp

    end

    def set_delete_forms

      if params[:delete_form_data].nil?

        form = Form.where("id = ?",params[:id]).first

        @forms=[form]


      else
        data=params[:delete_form_data]
        data=data.tr('{','')
        data=data.tr('}','')

        ids = data.split(",")

        @forms = []

        ids.each do |form_id|

            form = Form.where("id = ?",form_id)

            if form.first.nil?

              return false

            end

            @forms<<form.first

        end
      end

    end

    def set_edit_forms
      data=params[:edit_form_data]
      data=data.tr('{','')
      data=data.tr('}','')

      ids = data.split(",")

      @forms = []

      ids.each do |form_id|

          form = Form.where("id = ?",form_id)

          if form.first.nil?

            return false

          end

          @forms<<form.first
      end
    end

    def set_update_forms
      data=params[:update_form_data]

      formsArray = ActiveSupport::JSON.decode(data)

      @forms = []

      formsArray.each do |form_hash|

          form = Form.where("id = ?",form_hash["id"]).first

          @template=form.template

          #form.setData(form_hash)

          #id = dataIn["ID"]
      #dataIn.except!("ID")
          form.recipients = form_hash["recipients"]
          form_hash.except!("recipients")
          form.data=form_hash.to_json


          @forms<<form

          
      end


    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def form_params
      params.require(:form).permit(:template_id, :creator, :recipients, :private)
    end
   
    def getForms

      forms = params[:create_form_data]

      formsArray = ActiveSupport::JSON.decode(forms)

      return formsArray

      #formsArray.each do |form|

      #  logger.info "READ FORM: " + form["Notification emails"]

      #end

      #singleFields = forms.split("{{")

      #retdat = []

      #singleFields.each do |field|

       #   if field != ""

        #    retdat << field.tr('}}','')

         # end

      #end

      #return retdat

   end   

   

   def validate(myform)

      fields = @template.getFields

      datas = myform.getData

      if fields.length != datas.length

        logger.info "FIELDS "+fields.length.to_s+ " DATA "+datas.length.to_s

        return false

      else

        # Todo pending to check proper data type

        return true

      end




   end


end

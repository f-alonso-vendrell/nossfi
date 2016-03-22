class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit]
  before_action :set_delete_reports, only: [:destroy]
  before_action :set_update_reports, only: [:update]

  respond_to :html

  def index

    @duration = 60

    if ! params["duration"].nil?

      @duration = params["duration"].to_i

    end

    if ! params["template_report_id"].nil?

      @template = TemplateReport.find(params["template_report_id"])

      if ! @template.nil?

        

           @reports = Report.where("template_report_id = ? and updated_at >= ?",@template.id,Date.today-@duration)

           respond_to do |format|
              format.html { render action: 'index_simple.html'}
              format.json 
            end

       else
          @reports = Report.all
        end

    else
        @reports = Report.all
    end
    #respond_with(@reports)
  end

  def show
    @result=JSON.parse(@report.result)
    respond_with(@report)
  end

  def new
    @report = Report.new
    @report.template_report_id = params[:template_report_id]
    respond_with(@report)
  end

  def edit
  end

  def create

  #  template = report_params[:template_report_id]

# currently data is not used
  #  data = report_params[:data]


    @report = Report.new(report_params)

  #  @report = Report.new

   #  @report.template_report_id = template
    @report.creator = current_user.id


    # based on the template_report definition

    @template_report = TemplateReport.find(@report.template_report_id)

    result=Hash.new

    @template_report.getData.each do |table|

      table_id=table[0]
      table_filter=table[1]
      table_grouper=table[2]
      table_name=table[3]

      result[table_name]=Hash.new

      logger.info "Report on "+table_id+" "+table_name

      table_def=Template.find(table_id)


      forms_tmp = Form.where("template_id = ?",table_id)

      forms_tmp.each do |form|

        form_data_json = ActiveSupport::JSON.decode(form.as_json["data"])
        form_data_json["created_at"]=form.created_at.to_s
        form_data_json["updated_at"]=form.updated_at.to_s
        form_data_json["id"]=form.id
        form_data_json["template_id"]=form.template_id
        form_data_json["creator"]=form.creator.to_s


        if ! report_filter(table_filter,form_data_json)

          next

        end

        group_string = report_grouper(table_grouper,form_data_json)

        if result[table_name][group_string].nil? 

          result[table_name][group_string] = Hash.new

        end

        form_data_json.keys.each do |key|

          if table_def.isFieldNum(key)

            if result[table_name][group_string][key].nil?

              result[table_name][group_string][key]=Hash.new
              result[table_name][group_string][key]["count"]=1
              if form_data_json[key] == ""
                result[table_name][group_string][key]["count_empty"]=1
                result[table_name][group_string][key]["sum"]=0
                result[table_name][group_string][key]["max"]=-Float.MAX
                result[table_name][group_string][key]["min"]=Float.MAX

              else
                result[table_name][group_string][key]["count_empty"]=0
                result[table_name][group_string][key]["sum"]=form_data_json[key].to_f
                result[table_name][group_string][key]["max"]=form_data_json[key].to_f
                result[table_name][group_string][key]["min"]=form_data_json[key].to_f
              end

            else

              result[table_name][group_string][key]["count"]=result[table_name][group_string][key]["count"]+1
              result[table_name][group_string][key]["sum"]=result[table_name][group_string][key]["sum"]+form_data_json[key].to_f
              if form_data_json[key].to_f > result[table_name][group_string][key]["max"]
                result[table_name][group_string][key]["max"]= form_data_json[key].to_f
              end
              if form_data_json[key].to_f < result[table_name][group_string][key]["min"]
                result[table_name][group_string][key]["min"]= form_data_json[key].to_f
              end

            end

          end


        end



        

        

      end

      logger.info "Report result "+result.to_s


    end

    @report.result=result.to_json





    @report.save
    respond_with(@report)
  end

  def update


    if @reports.length == 0

      errorspresent=true

    end

    myerrors = []
    notifications = []
    
    @reports.each do |report|

      
      logger.info "about to update"+report.data
        

      #if validate(report)

        report.creator = current_user.id

        if ! report.save
          logger.info "ERROR SAVING report"+report.data
          myerrors << "Error with "+report.data
          errorspresent=true
        
        end
      #else
      #  logger.info "ERROR VALIDATING report"+report.data
      #  myerrors << "Error with "+report.data
      #  errorspresent=true
      #end

    end

   

    if (errorspresent)
      logger.info "ERROR PRESENT"
      redirect_to :back

    else
       redirect_to :controller => 'reports', :action => 'index', :template_report_id => @template.id, notice: 'reports were successfully created.'
    end





  end

  def destroy

    template_report_id = @reports.first.template_report_id

    notifications = []

    @reports.each do |report|

      logger.info "destroying"+report.id.to_s

      # notification = Notification.new
      #     notification.id = report.id
      #     notification.recipients = report.recipients
      #     notification.act = "deleted"
      #     notification.from = current_user.email
      #     notifications << notification

      report.destroy

    end

    notifications.each do |notif|

      UserMailer.notification_email(notif).deliver!

    end

    respond_to do |format|
      format.html { redirect_to :controller => 'reports', :action => 'index',:template_report_id => template_report_id }
      format.json { head :no_content }
    end


   # @report.destroy
   # respond_with(@report)
  end

  private

    def report_filter(table_filter,form_data_json)

      logger.info "REPORT FILTER FOR: "+table_filter

      if table_filter.nil? or table_filter==""

        return true

      end

      @cur_filter= Filter.where("id = ?",table_filter).first
       if @cur_filter.nil?
        return true
       end

       return @cur_filter.match(form_data_json)

    end

    def report_grouper(table_grouper,form_data_json)

      logger.info "REPORT GROUPER FOR: "+table_grouper

      if table_grouper.nil? or table_grouper==""

        return ""

      end

      @cur_grouper= Grouper.where("id = ?",table_grouper).first
       if @cur_grouper.nil?
        return ""
       end

       return @cur_grouper.getGroup(form_data_json)


    end


    def set_report
      @report = Report.find(params[:id])
    end

    def report_params
      params.require(:report).permit(:template_report_id, :creator, :data)
    end

     def set_delete_reports

      if params[:delete_report_data].nil?

        report = Report.where("id = ?",params[:id]).first

        @reports=[report]


      else
        data=params[:delete_report_data]
        data=data.tr('{','')
        data=data.tr('}','')

        ids = data.split(",")

        @reports = []

        ids.each do |report_id|

            report = Report.where("id = ?",report_id)

            if report.first.nil?

              return false

            end

            @reports<<report.first

        end
      end

    end

  def set_update_reports
      data=params[:update_report_data]

      reportsArray = ActiveSupport::JSON.decode(data)

      @reports = []

      reportsArray.each do |report_hash|

          report = Report.where("id = ?",report_hash["id"]).first

          @template=report.template_report

          #report.setData(report_hash)

          #id = dataIn["ID"]
      #dataIn.except!("ID")
          
          
          report.data=report_hash.to_json


          @reports<<report

          
      end


    end



end

class TemplateReportsController < ApplicationController
  before_action :set_template_report, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @template_reports = TemplateReport.all
    respond_with(@template_reports)
  end

  def show
    respond_with(@template_report)
  end

  def new
    @template_report = TemplateReport.new
    @templates = Template.all
    @filters = Filter.all
    @groupers = Grouper.all
    respond_with(@template_report)
  end

  def edit
  end

  def create
    @template_report = TemplateReport.new(template_report_params)
    @template_report.save
    respond_with(@template_report)
  end

  def update
    @template_report.update(template_report_params)
    respond_with(@template_report)
  end

  def destroy
    @template_report.destroy
    respond_with(@template_report)
  end

  private
    def set_template_report
      @template_report = TemplateReport.find(params[:id])
    end

    def template_report_params
      params.require(:template_report).permit(:title, :desc, :fields, :data, :creator)
    end
end

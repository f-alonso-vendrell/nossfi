json.array!(@template_reports) do |template_report|
  json.extract! template_report, :id, :title, :desc, :fields, :data, :creator
  json.url template_report_url(template_report, format: :json)
end

json.array!(@reports) do |report|
  json.extract! report, :id, :template_report_id, :creator, :data
  json.url report_url(report, format: :json)
end

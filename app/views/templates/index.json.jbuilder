json.array!(@templates) do |template|
  json.extract! template, :id, :title, :desc, :version, :fields, :aprovable, :acknowledgeable, :defaultemail
  json.url template_url(template, format: :json)
end

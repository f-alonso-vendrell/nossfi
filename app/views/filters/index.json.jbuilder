json.array!(@filters) do |filter|
  json.extract! filter, :id, :model, :name, :code
  json.url filter_url(filter, format: :json)
end

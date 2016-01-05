json.template do |json|

   json.array!(@template.getFields)

end

json.forms do |json|

	json.array!(@forms) do |form|
	  json.extract! form, :id
	  json.data ActiveSupport::JSON.decode(form.data)
	end

end

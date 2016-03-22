class Report < ActiveRecord::Base

	belongs_to :template_report


	def getData

      # return data.split("{")
      return ActiveSupport::JSON.decode(data)   

      rescue JSON::ParserError  
  
            return data.split("{")

   end   

   def getDataVal(dataIn)

   	   return ""

   	   # once data is used as input to filter remove first return statement

      json = getData()

      logger.info id.to_s + "getDataVal Read: "+json.to_s

      if json.has_key?(dataIn)

         return json[dataIn]

      else

         return ""

      end


   end
   
end

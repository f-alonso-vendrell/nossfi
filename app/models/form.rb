class Form < ActiveRecord::Base

  audited

   belongs_to :template

   #serialize :data, Hash

   def getData

      # return data.split("{")
      return ActiveSupport::JSON.decode(data)   

      rescue JSON::ParserError  
  
            return data.split("{")

   end   

   def setData(dataIn)

        #id = dataIn["ID"]
        #dataIn.except!("ID")
        recipients = dataIn["recipients"]
        dataIn.except!("recipients")
        data=dataIn.to_json

   end

   def getDataVal(dataIn)

      json = getData()

      logger.info id.to_s + "getDataVal Read: "+json.to_s

      if json.has_key?(dataIn)

         return json[dataIn]

      else

         return ""

      end


   end

end

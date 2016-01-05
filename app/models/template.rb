class Template < ActiveRecord::Base

   audited

	has_many :forms
   belongs_to :user, primary_key: "id", foreign_key: "creator"
	validates :title,:desc,:creator,:templateVersion,:fields, presence: true


   def getFieldsNames

   	singleFields = fields.split("{{")

   	retdat = []

   	singleFields.each do |field|

        if field != ""

   			retdat << field.split("}{").first
   		end

   	end

   	return retdat

   end	

   def getFields

      singleFields = fields.split("{{")

      retdat = []

      singleFields.each do |field|

          if field != ""

            data = field.split("}{")
            data[-1]=data.last.tr('}}','')
            retdat<<data

         end

      end

      return retdat

   end   

   def getFieldsAsCsv

      if fields.nil?
         return ",,,,"
      end

      singleFields = fields.split("{{")

      retdat = ""

      singleFields.each do |field|

         if field != ""

            # field = field.tr(',',';')
            data = field.split("}{")
            data[-1]=data.last.tr('}}','')
            retdat = retdat + data.join(',') + "\\n"

         end

      end

      return retdat

   end   

   def getFieldsAsJavascriptArray

     if fields.nil?
         return "[\'\',\'\',\'\',\'\',\'\']"
      end

      singleFields = fields.split("{{")

      retdat = "["

      singleFields.each do |field|

         if field != ""

            # field = field.tr(',',';')
            data = field.split("}{")
            data[-1]=data.last.tr('}}','')
            retdat = retdat + '["' + data.join('","') + "\"],"

         end

      end

      retdat = retdat + "]"

      return retdat


   end

   def isLastVersion

      return ( childtemplates.nil? || childtemplates == 0)
      
   end

   def isUsed

      @forms_ref = Form.where("template_id = ?",id)

      return (! @forms_ref.first.nil?)

   end

end


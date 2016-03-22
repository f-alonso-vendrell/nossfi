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

   def isFieldNum(fieldName)

      fields = getFields

      fields.each do |field|

         if field[0] == fieldName and field[3]=="numeric"

            return true

         end

      end

      return false

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

   def getVarsGrammar

      

      # predefined vars

      @boolean_vars = ["private"]
      @numeric_vars = ["template_id","creator","id"]
      @string_vars = ["recipients","created_at","updated_at"]

      # vars from template

      getFields.each do |field|

        if field[3] == "numeric" 
          
          @numeric_vars << field[0]

        elsif field[3] == "checkbox"

          @boolean_vars << field[0]

        else 

          @string_vars << field[0]

        end


      end


      grammar = 'grammar VarTypes

  rule boolean_var
     "' + @boolean_vars.join('" / "') + '" 
  end

  rule number_var
     "' + @numeric_vars.join('" / "') + '" 
  end

  rule string_var
     "' + @string_vars.join('" / "') + '" 
  end

  end'

      return grammar

   end


end


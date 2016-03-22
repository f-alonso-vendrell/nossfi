class TemplateReport < ActiveRecord::Base

	

   def getFields

      # Until Filters accpet pparameters empty fields returned

      retdat = []

      return retdat


      singleFields = data.split("{{")

      retdat = []

      singleFields.each do |field|

          if field != ""

            data_tmp = field.split("}{")
            data_tmp[-1]=data_tmp.last.tr('}}','')
            retdat<<data_tmp

         end

      end

      return retdat

   end   

   def getData

      singleFields = data.split("{{")

      retdat = []

      singleFields.each do |field|

          if field != ""

            data_tmp = field.split("}{")
            data_tmp[-1]=data_tmp.last.tr('}}','')
            retdat<<data_tmp

         end

      end

      return retdat


   end


end

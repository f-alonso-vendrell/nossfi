class Grouper < ActiveRecord::Base

	def getVarsGrammar

      @template = Template.find(template)

      return @template.getVarsGrammar()
   
   end


   def getGroup(json_data)

   	logger.info "GET GROUP CALLED"

   	Treetop.load_from_string(getVarsGrammar())

   	Treetop.load "app/controllers/string"

   	Treetop.load "app/controllers/string_ops"

   	@parser = StringOpsParser.new

   	logger.info "GROUP DATA: "+json_data.to_s
    logger.info "CODE: "+code

    result = @parser.parse( code )

    if ! result

       logger.info "GROUP PARSER FAILURE REASON: "+ @parser.failure_reason
       logger.info "GROUP PARSER FAILURE LINE: "+ @parser.failure_line.to_s
       logger.info "GROUP PARSER FAILURE COLUMN: "+ @parser.failure_column.to_s


    end



    return result.evaluate(json_data)

   end

end

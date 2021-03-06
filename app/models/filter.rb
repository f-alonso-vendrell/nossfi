class Treetop::Runtime::SyntaxNode
  def condition_identifiers
    []
  end
end

module StringVar


      def evaluate(env={})
        env[name]
      end
      
      def name
        text_value
      end
  


end

module BooleanVar


      def evaluate(env={})
        env[name]
      end
      
      def name
        text_value
      end
  


end

module NumberVar


      def evaluate(env={})
        env[name]
      end
      
      def name
        text_value
      end
  


end

module Decision
  def test_cases
    @test_cases ||= TestCaseSet.new(condition_identifiers, self)
  end

  def truth_table
    TruthTable.new(test_cases)
  end

  def mcdc_pairs
    test_cases.mcdc_pairs
  end
end

module BinaryOperation 
    include Decision
    def evaluate(env={})
      tail.elements.inject(head.evaluate(env)) do |value, element|
        element.mi_operator.apply(value, element.operand.evaluate(env))
      end
    end
  end

module Condition
  include Decision

  def condition_identifiers
    [text_value]
  end

  

  def evaluate(conditions={})

    #return text_value

    my_text=text_value

    if conditions.length > 0  and (! conditions[text_value].nil?)

      #return "hola"
      my_text=conditions[text_value]

    else
      #return "adios"
      #text_value=conditions[text_value]
    end

    #return text_value

    if my_text == "true"
      return true
    elsif my_text == "false"
      return false
    else
      return my_text
    end
  end
end

module BinaryDecision
  include Decision

  def condition_identifiers
    elements.map(&:condition_identifiers).flatten
  end

  def evaluate(conditions={})
    left  = operand_1.evaluate(conditions)
    right = operand_2.evaluate(conditions)
    operator.apply(left, right)
  end
end

module Negation
  include Decision

  def condition_identifiers
    operand.condition_identifiers
  end

  def evaluate(conditions)
    negate(operand.evaluate(conditions))
  end

  def negate(value)
    not value
  end
end

module Parenthesized
  include Decision

  def condition_identifiers
    contents.condition_identifiers
  end

  def evaluate(conditions)
    contents.evaluate(conditions)
  end
end

module And
  def apply(a, b)
    a & b
  end
end

module Or
  def apply(a, b)
    a | b
  end
end

module Xor
  def apply(a, b)
    a ^ b
  end
end


module BasicString

  def evaluate(env={})
    text_value[1..-2].to_s
  end
    
end

module StringVar

  def evaluate(env={})
    env[name]
  end
  
  def name
    text_value
  end

end

module StringOperation 
    
    def evaluate(env={})

      stack_tmp = Array.new
      
      stack_tmp = tail.evaluate(env)

      val = head.evaluate(env)

      stack_tmp.reverse_each do |method|

        if method == "to_time"

          val=Time.parse(val)

        else

          val=val.send(method)

        end

      end

      val

    end
end

module MethodListOperation 
    
    def evaluate(env={})

      stack_tmp = Array.new

      stack_tmp = tail.evaluate(env)

      stack_tmp << head.evaluate(env)

      return stack_tmp

    end
end

module MethodListOperation2
    
    def evaluate(env={})

      stack_tmp = Array.new

      stack_tmp << text_value

      return stack_tmp

    end
end

class Filter < ActiveRecord::Base

   def getVarsGrammar

      @template = Template.find(template)

      return @template.getVarsGrammar()
   
   end

   def match(json_data)

    Treetop.load_from_string(getVarsGrammar())

    Treetop.load "app/controllers/string"

    Treetop.load "app/controllers/logic"

    @parser = LogicParser.new

    logger.info "MATCH DATA: "+json_data.to_s
    logger.info "CODE: "+code

    result = @parser.parse( code )

    if ! result

       logger.info "PARSER FAILURE REASON: "+ @parser.failure_reason
       logger.info "PARSER FAILURE LINE: "+ @parser.failure_line.to_s
       logger.info "PARSER FAILURE COLUMN: "+ @parser.failure_column.to_s


    end

    return result.evaluate(json_data)

   end

end

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


class Filter < ActiveRecord::Base

   def getVarsGrammar

      @template = Template.find(template)

      # predefined vars

      @boolean_vars = ["private"]
      @numeric_vars = ["template_id","creator","id"]
      @string_vars = ["recipients","created_at","updated_at"]

      # vars from template

      @template.getFields.each do |field|

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

   def match(json_data)

    Treetop.load_from_string(getVarsGrammar())

    Treetop.load "app/controllers/logic"

    @parser = LogicParser.new

    logger.info "MATCH DATA: "+json_data.to_s
    logger.info "CODE: "+code

    return @parser.parse( code ).evaluate(json_data)

   end

end

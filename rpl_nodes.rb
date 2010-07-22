module Rpl
  class RplExpression < Treetop::Runtime::SyntaxNode
    def eval(context = RplContext.new)
      context = exp.eval(context)
      context
    end
  end

  class RplOperator < Treetop::Runtime::SyntaxNode
    def eval(context)
      puts "NOOP #{self.class}"
      context
    end
  end

  class RplOperation < Treetop::Runtime::SyntaxNode
    def eval(context)
      # TODO: implement real operators
      if self.operator.text_value == "+"
        context.last_return = var1.internal_value(context) + var2.internal_value(context)
      else
        puts "NOOP #{self.class} (#{self.operator.text_value.inspect})"
      end

      context
    end
  end

  class RplAssignment < Treetop::Runtime::SyntaxNode
    def eval(context)
      ret = nil
      first_element = var2.elements.first

      if first_element.respond_to?(:internal_value)
        ret = first_element.internal_value(context)
      else
        if first_element.is_a?(Rpl::RplOperation)
          ret = first_element.eval(context).last_return
        else
          raise "WTF got a #{first_element.class}"
        end
      end

      context.set_variable(var1.text_value, ret)
      context
    end
  end

  class RplNumber < Treetop::Runtime::SyntaxNode
    def internal_value(context)
      text_value.to_i
    end

    def eval(context)
      context
    end
  end

  class RplString < Treetop::Runtime::SyntaxNode
    def internal_value(context)
      text_value[1..-2]
    end

    def eval(context)
      context
    end
  end

  class RplVariable < Treetop::Runtime::SyntaxNode
    def internal_value(context)
      context.get_variable(text_value)
    end

    def eval(context)
      context
    end
  end
end

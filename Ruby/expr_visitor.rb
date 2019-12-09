class ExprVisitor
    def visit_binary(expr)
        raise NotImplementedError.new("ExprVisitor must be implemented!")
    end

    def visit_unary(expr)
        raise NotImplementedError.new("ExprVisitor must be implemented!")
    end

    def visit_grouping(expr)
        raise NotImplementedError.new("ExprVisitor must be implemented!")
    end

    def visit_literal(expr)
        raise NotImplementedError.new("ExprVisitor must be implemented!")
    end
end

class ExprEvaluator < ExprVisitor
    def initialize(machine=nil)
        @machine = machine
    end

    def visit_binary(expr)
        _result  = 0
        _handler = VariableHandler.new

        _left_evaluated  = expr.left.accept(self)
        _right_evaluated = expr.right.accept(self)

        case expr.operator.type
        when :plus
            _result = _handler.add(_left_evaluated, _right_evaluated)
        when :minus
            _result = _handler.sub(_left_evaluated, _right_evaluated)
        when :star
            _result = _handler.mult(_left_evaluated, _right_evaluated)
        when :slash
            _result = _handler.div(_left_evaluated, _right_evaluated)

        when :equal_equal
            _result = _handler.equal(_left_evaluated, _right_evaluated)
        when :not_equal
            _result = _handler.not_equal(_left_evaluated, _right_evaluated)
        when :greater
            _result = _handler.greater(_left_evaluated, _right_evaluated)
        when :greater_equal
            _result = _handler.greater_equal(_left_evaluated, _right_evaluated)
        when :lesser
            _result = _handler.lesser(_left_evaluated, _right_evaluated)
        when :lesser_equal
            _result = _handler.lesser_equal(_left_evaluated, _right_evaluated)
        end

        _result
    end

    def visit_unary(expr)
        _result  = expr.expression.accept(self)
        _handler = VariableHandler.new

        case expr.operator.type
        when :minus
            _result = _handler.minus(_result)
        when :not
            _result = _handler.not(_result)
        end

        _result
    end

    def visit_grouping(expr)
        expr.expression.accept(self)
    end

    def visit_func_call(expr)
        _evaluated_args = []

        expr.arguments.each {|arg| _evaluated_args.push(arg.accept(self)) }

        @machine.call_func(expr.identifier.lexeme, _evaluated_args)
    end

    def visit_literal(expr)
        if expr.token.type? :identifier
            _variable = @machine.get_variable expr.token.lexeme

            if _variable == nil
                puts "Undefined variable #{expr.token.lexeme} referenced on line #{expr.token.line} and column #{expr.token.column}"
                exit
            end

            return _variable
        end

        return Variable.from_token expr.token
    end
end
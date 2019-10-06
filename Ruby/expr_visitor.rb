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
    def visit_binary(expr)
        _result = 0

        _left_evaluated  = expr.left.accept(self)
        _right_evaluated = expr.right.accept(self)

        case expr.operator.type
        when :plus
            _result = _left_evaluated + _right_evaluated
        when :minus
            _result = _left_evaluated - _right_evaluated
        when :star
            _result = _left_evaluated * _right_evaluated
        when :slash
            _result = _left_evaluated / _right_evaluated
        end

        _result
    end

    def visit_unary(expr)
        _result = expr.expression.accept(self)

        case expr.operator.type
        when :minus
            _result = -_result
        end

        _result
    end

    def visit_grouping(expr)
        expr.expression.accept(self)
    end

    def visit_literal(expr)
        expr.token.lexeme.to_f
    end
end
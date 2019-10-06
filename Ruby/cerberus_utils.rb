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

class PrintExprVisitor < ExprVisitor
    def visit_binary(expr)
        "(#{expr.operator.lexeme} #{expr.left.accept(self)} #{expr.right.accept(self)})"
    end

    def visit_unary(expr)
        "(#{expr.operator.lexeme} #{expr.expression.accept(self)})"
    end

    def visit_grouping(expr)
        "(#{expr.expression.accept(self)})"
    end

    def visit_literal(expr)
        "#{expr.token.lexeme}"
    end
end
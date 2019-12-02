class Expr
    def accept(visitor)
        raise NotImplementedError.new("Expr.accept(visitor) must be implemented!")
    end
end

class BinaryExpr
    attr_accessor :left
    attr_accessor :operator
    attr_accessor :right

    def initialize(left_expr, operator, right_expr)
        @left     = left_expr
        @operator = operator
        @right    = right_expr
    end

    def accept(visitor)
        visitor.visit_binary(self)
    end
end

class UnaryExpr
    attr_accessor :operator
    attr_accessor :expression

    def initialize(operator, expression)
        @operator   = operator
        @expression = expression
    end

    def accept(visitor)
        visitor.visit_unary(self)
    end
end

class GroupingExpr
    attr_accessor :expression

    def initialize(expression)
        @expression = expression
    end

    def accept(visitor)
        visitor.visit_grouping(self)
    end
end

class FuncCallExpr
    attr_accessor :identifier
    attr_accessor :arguments

    def initialize(identifier, arguments = [])
        @identifier = identifier
        @arguments  = arguments
    end

    def add_arg(expression)
        @arguments.push(expression)
    end

    def accept(visitor)
        visitor.visit_func_call(self)
    end
end

class LiteralExpr
    attr_accessor :token

    def initialize(token)
        @token = token
    end

    def accept(visitor)
        visitor.visit_literal(self)
    end
end
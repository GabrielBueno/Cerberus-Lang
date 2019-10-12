class Stmt
end

class AssignmentStmt < Stmt
    attr_accessor :assignment_op
    attr_accessor :identifier
    attr_accessor :expr

    def initialize(identifier, assignment_op, expr)
        @assignment_op = assignment_op
        @identifier    = identifier
        @expr          = expr
    end

    def accept(visitor)
        visitor.visit_assignment(self)
    end
end

class PrintStmt < Stmt
    attr_accessor :expr

    def initialize(expr)
        @expr = expr
    end

    def accept(visitor)
        visitor.visit_print(self)
    end
end
# Statement genérico
class Stmt
end

class ProgramStmt
    attr_accessor :stmts

    def initialize
        @stmts = []
    end

    def add_stmt(stmt)
        @stmts.push stmt
    end

    def accept(visitor)
        visitor.visit_program(self)
    end
end

class VariableDeclarationStmt < Stmt
    attr_accessor :mutable
    attr_accessor :identifier
    attr_accessor :type
    attr_accessor :expr

    def initialize(mutable, identifier, type, expr)
        @mutable    = mutable
        @identifier = identifier
        @type       = type
        @expr       = expr
    end

    def accept(visitor)
        visitor.visit_var_declaration(self)
    end
end

# Declaração de variável
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

# Print
class PrintStmt < Stmt
    attr_accessor :expr

    def initialize(expr)
        @expr = expr
    end

    def accept(visitor)
        visitor.visit_print(self)
    end
end
    
# Statement de expressões
class ExprStmt < Stmt
    attr_accessor :expr

    def initialize(expr)
        @expr = expr
    end

    def accept(visitor)
        visitor.visit_expr(self)
    end
end

# If statement
class IfStmt < Stmt
    attr_accessor :expr
    attr_accessor :block
    attr_accessor :else_stmt
    attr_accessor :elif_stmts

    def initialize(expr, block)
        @expr  = expr
        @block = block

        @elif_stmts = []
        @else_stmt  = nil
    end

    def add_elif(elif_stmt)
        @elif_stmts.push(elif_stmt)
    end

    def set_else(else_stmt)
        @else_stmt = else_stmt
    end

    def accept(visitor)
        visitor.visit_if(self)
    end

    def has_else?
        @else_stmt != nil
    end

    def has_elif?
        @elif_stmts.length > 0
    end

    # Else stmt
    class Else
        attr_accessor :block

        def initialize(block)
            @block = block
        end

        def accept(visitor)
            visitor.visit_else(self)
        end
    end

    # Elif stmt
    class Elif
        attr_accessor :expr
        attr_accessor :block

        def initialize(expr, block)
            @expr  = expr
            @block = block
        end

        def accept(visitor)
            visitor.visit_elif(self)
        end
    end
end

class WhileStmt
    attr_accessor :expr
    attr_accessor :block

    def initialize(expr, block)
        @expr  = expr
        @block = block
    end

    def accept(visitor)
        visitor.visit_while(self)
    end
end

class Block
    attr_accessor :stmts

    def initialize()
        @stmts = []
    end

    def add_stmt(stmt)
        @stmts.push(stmt)
    end

    def accept(visitor)
        visitor.visit_block(self)
    end
end
class CerberusMachine
    attr_accessor :program
    attr_accessor :memory
    attr_accessor :super_scope

    def initialize(program, super_scope=nil)
        @program     = program
        @super_scope = super_scope
        @memory      = {}
    end

    def run
        program.stmts.each { |stmt| stmt.accept(self) }
        
        print_memory()
    end

    def visit_print(print_stmt)
        puts print_stmt.expr.accept(ExprEvaluator.new)
    end

    def visit_var_declaration(let_stmt)
        if (get_variable(let_stmt.identifier.lexeme) != nil)
            puts "Variable '#{let_stmt.identifier.lexeme}' already defined in scope"

            exit
        end

        assigned_value = let_stmt.expr ? let_stmt.expr.accept(ExprEvaluator.new) : nil

        add_variable let_stmt.identifier.lexeme, Variable.new(let_stmt.identifier.lexeme, let_stmt.mutable, let_stmt.type, assigned_value)

        # print_memory()
    end

    def visit_assignment(assignment_stmt)
        _variable = get_variable(assignment_stmt.identifier.lexeme)

        if _variable == nil
            puts "Variable '#{assignment_stmt.identifier.lexeme}' doesn't exists"
            exit
        end

        _variable.value = assignment_stmt.expr.accept(ExprEvaluator.new)

        # print_memory()
    end

    def visit_expr(expr_stmt)
        expr_stmt.expr.accept(ExprEvaluator.new)
    end

    def visit_if(if_stmt)
        if_expr_evaluated = if_stmt.expr.accept(ExprEvaluator.new)

        # If
        if if_expr_evaluated

            run_block if_stmt.block

            return
        end

        # Elif
        if_stmt.elif_stmts.each do |elif_stmt|
            elif_expr_eval = elif_stmt.expr.accept(ExprEvaluator.new)

            next if !elif_expr_eval

            run_block elif_stmt.block

            return
        end

        # Else
        if if_stmt.has_else?
            run_block if_stmt.else_stmt.block
        end
    end

    def visit_while(while_stmt)
        while while_stmt.expr.accept(ExprEvaluator.new)
            run_block while_stmt.block
        end
    end

protected
    def get_variable(identifier)
        @memory[identifier] || (super_scope.get_variable(identifier) if super_scope != nil)
    end

private
    def run_block(block)
        block_program = ProgramStmt.new block.stmts
        sub_scope     = CerberusMachine.new block_program, self

        sub_scope.run()
    end

    def add_variable(identifier, variable)
        @memory[identifier] = variable
    end

    def print_memory
        puts "Memory...\n"

        @memory.each do |key, value|
            puts "#{key} => #{value.value}"
        end

        puts ""
    end
end

class Variable
    TYPES = [
        "u8", "u16", "u32",
        "i8", "i16", "i32",
        "int", "double", "string"
    ]

    attr_accessor :identifier
    attr_accessor :mutable
    attr_accessor :type
    attr_accessor :value

    def initialize(identifier, mutable, type, value)
        @identifier = identifier
        @mutable    = mutable
        @type       = type
        @value      = value

        validate_type
    end

private
    def validate_type
        return if valid_type?

        puts "ERROR: Type '#{@type.lexeme}' of variable '#{@identifier}' is not a valid type"
        exit
    end

    def validate_value

    end

    def valid_type?
        TYPES.include? @type
    end
end
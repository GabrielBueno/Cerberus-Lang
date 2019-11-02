class CerberusMachine
    attr_accessor :program
    attr_accessor :memory
    attr_accessor :super_scope

    def initialize(program, super_scope=nil)
        @program     = program
        @super_scope = super_scope
        @memory      = {}
        @expr_eval   = ExprEvaluator.new self
    end

    def run
        program.stmts.each do |stmt|
            stmt.accept(self)
        end
    end

    def visit_print(print_stmt)
        puts print_stmt.expr.accept(@expr_eval).to_s
    end

    def visit_var_declaration(let_stmt)
        if (get_variable(let_stmt.identifier.lexeme) != nil)
            puts "Variable '#{let_stmt.identifier.lexeme}' already defined in scope"
            exit
        end

        # Obtém o valor atribuido, caso exista, e cria a variável declarada
        _assigned_value    = let_stmt.expr ? let_stmt.expr.accept(@expr_eval) : nil
        _variable_declared = Variable.new(let_stmt.identifier.lexeme, let_stmt.mutable, let_stmt.type.lexeme);

        # Caso tenha valor atribuído, realiza tal ação
        _variable_declared.receive_variable(_assigned_value) if _assigned_value != nil

        if _variable_declared.has_error?
            puts _variable_declared.error
            exit
        end

        # Adiciona a variável
        add_variable let_stmt.identifier.lexeme, _variable_declared

        # print_memory()
    end

    def visit_assignment(assignment_stmt)
        _variable = get_variable(assignment_stmt.identifier.lexeme)

        if _variable == nil
            puts "Variable '#{assignment_stmt.identifier.lexeme}' doesn't exists"
            exit
        end

        _variable.receive_variable assignment_stmt.expr.accept(@expr_eval)

        if _variable_declared.has_error?
            puts _variable_declared.error
            exit
        end

        # print_memory()
    end

    def visit_expr(expr_stmt)
        expr_stmt.expr.accept(@expr_eval)
    end

    def visit_if(if_stmt)
        if_expr_evaluated = if_stmt.expr.accept(@expr_eval)

        # If
        if if_expr_evaluated.truthy?

            run_block if_stmt.block

            return
        end

        # Elif
        if_stmt.elif_stmts.each do |elif_stmt|
            elif_expr_eval = elif_stmt.expr.accept(@expr_eval)

            next if !elif_expr_eval.truthy?

            run_block elif_stmt.block

            return
        end

        # Else
        if if_stmt.has_else?
            run_block if_stmt.else_stmt.block
        end
    end

    def visit_while(while_stmt)
        while while_stmt.expr.accept(@expr_eval).truthy?
            run_block while_stmt.block
        end
    end

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
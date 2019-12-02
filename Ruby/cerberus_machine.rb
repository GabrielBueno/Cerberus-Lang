class CerberusMachine
    attr_accessor :program
    attr_accessor :memory
    attr_accessor :functions
    attr_accessor :super_scope

    def initialize(program, super_scope=nil)
        @program     = program
        @super_scope = super_scope
        @expr_eval   = ExprEvaluator.new self
        @memory      = {}
        @functions   = {}
    end

    def run
        program.stmts.each do |stmt|
            cmd_result = stmt.accept(self)

            return cmd_result if stmt.is_a? ReturnStmt
        end

        return nil
    end

    def visit_print(print_stmt)
        puts print_stmt.expr.accept(@expr_eval).to_s
    end

    def visit_var_declaration(let_stmt)
        if (!let_stmt.is_a?(ArgumentDeclarationStmt) && get_variable(let_stmt.identifier.lexeme) != nil)
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

        if _variable.has_error?
            puts _variable.error
            exit
        end

        # print_memory()
    end

    def visit_return(return_stmt)
        return_stmt.expression.accept(@expr_eval)
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

    def visit_for(for_stmt)
        # O for será transformado em um while, e jogado dentro de um bloco, para manter o escopo da variável declarada inicialmente
        _for_subblock     = Block.new
        _translated_while = WhileStmt.new for_stmt.expression, for_stmt.block

        _translated_while.block.add_stmt for_stmt.loop_statement

        _for_subblock.add_stmt for_stmt.initial_statement
        _for_subblock.add_stmt _translated_while

        run_block _for_subblock
    end

    def visit_func(func_stmt)
        if get_function(func_stmt.identifier) != nil
            puts "Função '#{func_stmt.identifier}' já declarada anteriormente"
            exit
        end

        add_function func_stmt
        # print_functions
    end

    def run_func(func_identifier, arg_list) 
        _func            = get_function(func_identifier.lexeme)
        _func_exec_block = FuncExecBlock.new

        if _func == nil
            puts "Função '#{func_identifier}' inexistente"
            exit
        end

        if _func.parameters.length != arg_list.length
            puts "Número de argumentos passados para a função é inválido"
            exit
        end

        for i in 0..(arg_list.length - 1) do
            _param = _func.parameters[i]
            _arg   = arg_list[i]
            _arg_token = Token.new :identifier, arg_var_decl_name(_param.identifier)

            _func_exec_block.add_stmt ArgumentDeclarationStmt.new _arg_token, _param.type, _arg
        end

        _func_exec_block.stmts.concat _func.block.stmts

        run_func_block _func_exec_block
    end

    def get_variable(identifier, search_super_scope = true)
        @memory[identifier] || @memory[arg_var_decl_name(identifier)] || (super_scope.get_variable(identifier) if super_scope != nil && search_super_scope)
    end

    def get_function(identifier, search_super_scope = true)
        @functions[identifier] || (super_scope.get_function(identifier) if super_scope != nil && search_super_scope)
    end

private
    def run_block(block)
        block_program = ProgramStmt.new block.stmts
        sub_scope     = CerberusMachine.new block_program, self

        sub_scope.run()
    end

    def run_func_block(block)
        block.stmts.each do |stmt|
            if stmt.is_a? Block
                return run_func_block(stmt)
            end

            cmd_result = stmt.accept(self)

            return cmd_result if stmt.is_a? ReturnStmt
        end
    end

    def arg_var_decl_name(var_name)
        "___arg__#{var_name}___"
    end

    def add_variable(identifier, variable)
        @memory[identifier] = variable
    end

    def add_function(func)
        @functions[func.identifier.lexeme] = func
    end

    def print_memory
        puts "Memory...\n"

        @memory.each do |key, value|
            puts "#{key} => #{value.value}"
        end

        puts ""
    end

    def print_functions
        puts "Functions...\n"

        @functions.each do |key, value|
            puts "#{key} => #{value}"
        end

        puts ""
    end
end
class Parser
    def initialize(tokens)
        @tokens  = tokens
        @errors  = []
        @current = 0
    end

    def parse
        program
    end

    def has_errors?
        @errors.length > 0
    end

    def show_errors
        @errors.each {|err| puts err }
    end

private
    def program
        _program = ProgramStmt.new

        _program.add_stmt(func_stmt()) while !ended?

        _program
    end

    def block
        if !current?(:left_curly_brackets)
            add_error("Expected opening curly brackets")

            return while_stmt()
        end

        # Elimina a chave de abertura
        consume()

        _block = Block.new

        while (!current?(:right_curly_brackets))
            if ended?()
                add_error("Expected closing curly brackets!")
            end

            _block.add_stmt(if_stmt())
        end

        # Elimina a chave de fechamento
        consume()

        _block
    end

    def func_stmt
        _param_list = []

        if !current?(:func)
            return while_stmt
        end

        consume()

        _func_identifier = consume()

        if !current?(:left_paren)
            add_error("Parênteses de abertura esperado em delcaração de função")

            return while_stmt
        end

        consume()

        while !current?(:right_paren)
            if ended?()
                add_error("Esperado fechamento de lista de parâmetros em declaração de função")

                return nil
            end

            _param_identifier = consume()

            if (!current?(:colon))
                add_error("Tipo do parâmetro esperado!")

                return while_stmt
            end

            consume()

            _param_type = consume()

            _param_list.push(ParameterDeclaration.new(_param_identifier, _param_type))

            if (!current?(:right_paren) && !current?(:comma))
                add_error("Vírgula de separação dos parâmetros esperada em declaração de função")

                return while_stmt
            elsif (current?(:comma))
                consume()
            end
        end

        consume()

        if (!current?(:colon))
            add_error("Definição do tipo do retorno esperado em declaração de função")

            return while_stmt
        end

        consume()

        _func_return_type = consume()
        _func_block       = block()

        return FuncStmt.new(_func_identifier, _func_return_type, _func_block, _param_list)
    end

    def while_stmt
        if !current?(:while)
            return for_stmt
        end

        consume()

        if !current?(:left_paren)
            add_error("Parênteses de abertura esperado em while!")

            return if_stmt
        end

        consume()

        _expression = expression

        if !current?(:right_paren)
            add_error("Parênteses de fechamento esperado em while!")

            return if_stmt
        end

        consume()

        _block = block

        WhileStmt.new _expression, _block
    end

    def elif_stmt
        if (!current?(:elif))
            return else_stmt
        end

        consume()

        # Verifica o parênteses de abertura
        if !current?(:left_paren)
            add_error("Expected opening parentheses in elif statement!")

            return assignment
        end

        # Elimina o parênteses de abertura
        consume()

        _expression = expression

        # Verifica o parênteses de fechamento
        if !current?(:right_paren)
            add_error "Expected closing parentheses"

            return assignment
        end

        # Elimina o parênteses de fechamento
        consume()

        _block = block

        IfStmt::Elif.new _expression, _block
    end

    def for_stmt
        _initial_statement = nil
        _expression        = nil
        _loop_statement    = nil
        _block             = nil

        if !current? :for
            return if_stmt
        end

        consume()

        # Verifica o parênteses de abertura
        if !current?(:left_paren)
            add_error "Expected opening parentheses in for statement!"
            return assignment
        end

        # Elimina o parênteses de abertura
        consume()

        _initial_statement = var_declaration
        
        # Semicolon
        if !current?(:semicolon)
            add_error "Expected ';' on for statement!"
            return assignment
        end

        consume()

        _expression = expression()

        # Semicolon
        if !current?(:semicolon)
            add_error "Expected ';' on for statement!"
            return assignment
        end

        consume()

        _loop_statement = assignment

        # Verifica o parênteses de fechamento
        if !current?(:right_paren)
            add_error "Expected closing parentheses in for statement!"
            return assignment
        end

        # Elimina o parênteses de fechamento
        consume()

        _block = block

        ForStmt.new _initial_statement, _expression, _loop_statement, _block
    end

    def else_stmt
        if (!current?(:else))
            return else_stmt
        end

        consume()

        _block = block

        IfStmt::Else.new _block
    end

    def if_stmt
        if current?(:if)
            consume()

            # Verifica o parênteses de abertura
            if !current?(:left_paren)
                add_error "Expected opening parentheses in if block!"

                return assignment
            end

            # Elimina o parênteses de abertura
            consume()

            # Constrói a árvore de expressões
            _expression = expression

            # Verifica o parênteses de fechamento
            if !current?(:right_paren)
                add_error "Expected closing parentheses"

                return assignment
            end

            # Elimina o parênteses de fechamento
            consume()

            _block   = block
            _if_stmt = IfStmt.new _expression, _block

            # Verifica se existem elif's
            while current?(:elif)
                _if_stmt.add_elif elif_stmt
            end

            # Verifica se existe else
            if current?(:else)
                _if_stmt.set_else else_stmt
            end

            return _if_stmt
        end

        var_declaration
    end

    def var_declaration
        while current?(:let)
            consume()

            _mutable = false
            _type    = nil
            _expr    = nil

            if current?(:mut)
                _mutable = true

                consume()
            end

            if !current?(:identifier)
                add_error "Expected identifier in variable declaration!"

                return print_stmt
            end

            _identifier = consume()

            if !current?(:colon)
                add_error "Expected type definition of variable '#{_identifier}'"

                return print_stmt
            end

            consume()

            if !current?(:identifier)
                add_error "Expected type definition of variable '#{_identifier}'"

                return print_stmt
            end

            _type = consume()

            if current?(:equal)
                consume()

                _expr = expression()
            end

            return VariableDeclarationStmt.new(_mutable, _identifier, _type, _expr)
        end

        print_stmt
    end

    def print_stmt
        if !current?(:print)
            return assignment
        end

        consume()
        return PrintStmt.new(expression())
    end

    def assignment
        if !current?(:identifier) || !next_token?(:equal)
            return return_stmt
        end

        identifier    = consume()
        assignment_op = consume()

        return AssignmentStmt.new(identifier, assignment_op, expression())
    end

    def return_stmt
        if !current?(:return)
            return expression_stmt
        end

        consume()

        return ReturnStmt.new expression
    end

    def expression_stmt
        return ExprStmt.new expression
    end

    def expression
        boolean
    end

    def boolean
        _expression = sum()

        while current?(:equal_equal) || current?(:not_equal) || current?(:greater) || current?(:greater_equal) || current?(:lesser) || current?(:lesser_equal)
            _operator = consume()
            _expression = BinaryExpr.new(_expression, _operator, sum())
        end

        _expression
    end

    def sum
        _expression = term()

        while current?(:plus) || current?(:minus)
            _operator   = consume()
            _expression = BinaryExpr.new(_expression, _operator, term())
        end

        _expression
    end

    def term
        _expression = factor()

        while current?(:star) || current?(:slash)
            _operator   = consume()
            _expression = BinaryExpr.new(_expression, _operator, factor())
        end

        _expression
    end

    def factor
        if current?(:left_paren)
            consume()

            _expression = GroupingExpr.new(expression())

            consume()

            return _expression
        else
            return unary()
        end
    end

    def unary
        if current?(:minus) || current?(:not)
            _operator = consume()
            return UnaryExpr.new(_operator, func_call())
        end

        return func_call()
    end

    def func_call
        _literal = consume()

        if current?(:left_paren)
            _args_list = []

            consume()

            while !current?(:right_paren)
                _args_list.push(expression())

                if !current?(:comma) && !current?(:right_paren)
                    add_error("Vírgula de separação dos argumentos esperada em execução de função")

                    return func_stmt
                elsif current?(:comma)
                    consume()
                end
            end

            consume()

            return FuncCallExpr.new _literal, _args_list
        end

        LiteralExpr.new _literal
    end

    def move_forward
        @current += 1
    end

    def move_backwards
        @current -= 1
    end

    def consume
        move_forward()
        return previous()
    end

    def current
        @tokens[@current]
    end

    def current?(token_type)
        current() != nil && current().type == token_type
    end

    def next_token
        @tokens[@current + 1]
    end

    def next_token?(type)
        next_token() != nil && next_token().type == type
    end

    def previous
        @current > 0 ? @tokens[@current - 1] : nil
    end

    def previous?(type)
        previous().type == type
    end

    def jump_to(token_type)
        while !current?(token_type)
            move_forward() 
        end
    end

    def ended?
        @current >= @tokens.length
    end

    def add_error(message, token=nil, exit_program=false)
        _token = token || current()

        @errors.push ">>> Parsing error: #{message}\n\tin line #{_token.line} and column #{_token.column}\n\n"

        exit if exit_program
    end
end
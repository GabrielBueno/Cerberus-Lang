class Parser
    def initialize(tokens)
        @tokens  = tokens
        @current = 0
    end

    def parse
        if_stmt
    end

    def block
        if !current?(:left_curly_brackets)
            puts "Expected opening curly brackets!"
            exit
        end

        # Elimina a chave de abertura
        consume()

        _block = Block.new

        while (!current?(:right_curly_brackets))
            if ended?()
                puts "Expected closing curly brackets!"
                exit
            end

            _block.add_stmt(if_stmt())
        end

        # Elimina a chave de fechamento
        consume()

        _block
    end

    def elif_stmt
        if (!current?(:elif))
            return else_stmt
        end

        consume()

        # Verifica o parênteses de abertura
        if !current?(:left_paren)
            puts "Expected opening parentheses!"

            return assignment
        end

        # Elimina o parênteses de abertura
        consume()

        _expression = expression

        # Verifica o parênteses de fechamento
        if !current?(:right_paren)
            puts "Expected closing parentheses"

            return assignment
        end

        # Elimina o parênteses de fechamento
        consume()

        _block = block

        IfStmt::Elif.new _expression, _block
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
                puts "Expected opening parentheses!"

                return assignment
            end

            # Elimina o parênteses de abertura
            consume()

            # Constrói a árvore de expressões
            _expression = expression

            # Verifica o parênteses de fechamento
            if !current?(:right_paren)
                puts "Expected closing parentheses"

                return assignment
            end

            # Elimina o parênteses de fechamento
            consume()

            _block   = block
            _if_stmt = IfStmt.new _expression, _block

            # Verifica se existem elif's
            while (current?(:elif))
                _if_stmt.add_elif elif_stmt
            end

            # Verifica se existe else
            if (current?(:else))
                _if_stmt.set_else else_stmt
            end

            return _if_stmt
        end

        assignment
    end

    def assignment
        if current?(:let)
            consume()

            if !current?(:identifier)
                puts "Expected identifier"

                return print_stmt
            end

            identifier = consume()

            if !current?(:equal)
                puts "Expected assignment operation"

                return print_stmt
            end

            assignment_op = consume()

            return AssignmentStmt.new(identifier, assignment_op, expression())
        end

        print_stmt
    end

    def print_stmt
        if !current?(:print)
            return expression()
        end

        consume()
        return PrintStmt.new(expression())
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
            return UnaryExpr.new(_operator, literal())
        else
            return literal()
        end
    end

    def literal
        _operator = consume()

        LiteralExpr.new _operator
    end

private
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
        next_token().type == type
    end

    def previous
        @current > 0 ? @tokens[@current - 1] : nil
    end

    def previous?(type)
        previous().type == type
    end

    def ended?
        @current >= @tokens.length
    end
end
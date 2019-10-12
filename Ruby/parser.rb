class Parser
    def initialize(tokens)
        @tokens  = tokens
        @current = 0
    end

    def parse
        assignment()
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
end
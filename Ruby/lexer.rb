require_relative "token.rb"

class Lexer
    def initialize(input)
        @input   = input
        @tokens  = []
        @errors  = []
        @current = 0
        @reserved_keywords = {"let" => :let}
    end

    def tokens
        while (not ended?)
            case current
            when "("
                add_token(:left_paren, "(")
            when ")"
                add_token(:right_paren, ")")

            when "+"
                add_token(:plus, "+")
            when "-"
                add_token(:minus, "-")
            when "*"
                add_token(:star, "*")
            when "/"
                add_token(:slash, "/")

            when "="
                add_token(:equal, "=")
            when ";"
                add_token(:semicolon, ";")

            else
                if numeric?(current())
                    add_number()
                elsif alpha?(current())
                    add_identifier()
                else
                    @errors.push("Unexpected " + current())
                end
            end

            move_forward()
        end

        return @tokens
    end

private
    def move_forward
        @current += 1
    end

    def move_backwards
        @current = @current == 0 ? 0 : @current - 1
    end

    def current
        @input[@current]
    end

    def current?(match)
        current() == match
    end

    def previous
        @current > 0 ? @input[@current - 1] : nil
    end

    def previous?(match)
        previous() == match
    end

    def next_ch
        @input[@current + 1]
    end

    def next_ch?(match)
        next_ch() == match
    end

    def ended?
        @current >= @input.length
    end

    def numeric?(value)
        value != nil && value >= "0" && value <= "9"
    end

    def alpha?(value)
        value != nil && value == "_" || (value >= "a" && value <= "z") || (value >= "A" && value <= "Z")
    end

    def alphanumeric?(value)
        numeric?(value) || alpha?(value)
    end

    def add_token(token_type, lexeme = "")
        @tokens.push Token.new token_type, lexeme
    end

    def add_number
        _is_decimal = false
        _number     = ""

        while (numeric?(current()) || current?("."))
            # Verifica se é um número decimal
            if current?(".") && !_is_decimal
                _is_decimal = true
            elsif current?(".") && _is_decimal
                break # Caso encontre dois '.' no número, encerra o loop
            end

            # Concatena o caracter na cadeia que representa o número
            _number += current()

            # Move para o próximo caracter da entrada
            move_forward()
        end

        # Volta um caracter, para quando a condição do loop acima se mostrar falsa
        move_backwards()

        add_token(_is_decimal ? :double : :integer, _number)
    end

    def add_identifier
        _identifier = ""

        while (alphanumeric?(current()))
            _identifier += current()

            move_forward()
        end

        move_backwards()

        add_token(@reserved_keywords[_identifier] || :identifier, _identifier)
    end
end
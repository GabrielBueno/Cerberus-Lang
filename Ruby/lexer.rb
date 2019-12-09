require_relative "token.rb"

###
# --------------------------
# Lexer
#
# Máquina que transforma uma cadeida de caracteres (string), em uma cadeia
# de Tokens (lexemas) que constituem a linguagem
#
# Atributos:
#   - input: a cadeia de caracteres de entrada
#   - tokens: a lista de Tokens gerada como saída
#   - errors: uma lista de erros encontrados durante o processo de reconhecimento
#   - current: aponta para qual caracter da entrada que está sendo lido no estado corrente
#   - reserved_keywords: lista com as palavras reservadas da linguagem
# --------------------------
###
class Lexer
    # Construtor, recebe uma string, sobre a qual irá trabalhar
    def initialize(input)
        @input   = input
        @tokens  = []
        @errors  = []
        @current = 0
        @line    = 0
        @column  = 0
        @reserved_keywords = {
            "let"     => :let,
            "if"      => :if,
            "else"    => :else,
            "elif"    => :elif,
            "print"   => :print,
            "while"   => :while,
            "mut"     => :mut,
            "for"     => :for,
            "func"    => :func,
            "return"  => :return
        }
    end

    # Caso a lista de Tokens ainda não tenha sido gerada, realiza tal operação.
    # Caso já tenha sido gerada, somente retorna o resultado já obtido anteriormente
    def tokens
        if @tokens.length == 0
            tokenize()
        end

        @tokens
    end

    # Indica se erros foram encontrados no processo de reconhecimento da entrada
    def has_errors?
        @errors.length > 0
    end

    def show_errors
        @errors.each {|err| puts err }
    end

private
    # Itera sobre cada caracter da entrada, realizando a sua conversão
    # para a uma lista de Tokens da linguagem
    def tokenize
        while (not ended?)
            case current
            when " ", "\r", "\t"

            when "\n"
                @line  += 1
                @column = 1

            when "("
                add_token(:left_paren, "(")
            when ")"
                add_token(:right_paren, ")")
            when "{"
                add_token(:left_curly_brackets, "{")
            when "}"
                add_token(:right_curly_brackets, "}")

            when "+"
                add_token(:plus, "+")
            when "-"
                add_token(:minus, "-")
            when "*"
                add_token(:star, "*")
            when "/"
                add_token(:slash, "/")
            when "%"
                add_token(:module, "%")

            when "="
                if next_ch?("=")
                    add_token(:equal_equal, "==")
                    move_forward()
                else
                    add_token(:equal, "=")
                end

            when ">"
                if next_ch?("=")
                    add_token(:greater_equal, ">=")
                    move_forward()
                else
                    add_token(:greater, ">")
                end

            when "<"
                if next_ch?("=")
                    add_token(:lesser_equal, "<=")
                    move_forward()
                else
                    add_token(:lesser, "<")
                end

            when "!"
                if next_ch?("=")
                    add_token(:not_equal, "!=")
                    move_forward()
                else
                    add_token(:not, "!")
                end

            when ":"
                add_token(:colon, ":")
            when ";"
                add_token(:semicolon, ";")
            when ","
                add_token(:comma, ",")

            when "\""
                add_string()

            else
                if numeric?(current())
                    add_number()
                elsif alpha?(current())
                    add_identifier()
                else
                    @errors.push("Unexpected #{current()} found on line #{@line} and column #{@column}")
                end
            end

            move_forward()
        end
    end

    # Avança o ponteiro @current em uma posição
    def move_forward
        @current += 1
        @column  += 1
    end

    # Recua o ponteiro em uma posição
    def move_backwards
        @current = @current == 0 ? 0 : @current - 1
    end

    # Obtém o caracter lido atualmente
    def current
        @input[@current]
    end

    # Verifica se o caracter lido atualmente possui um determinado valor
    def current?(match)
        current() == match
    end

    # Obtém o caracter que está a uma posição atrás do ponteiro @current
    def previous
        @current > 0 ? @input[@current - 1] : nil
    end

    # Verifica se o caracter que está a uma posição atrás do ponteiro possui um determinado valor
    def previous?(match)
        previous() == match
    end

    # Obtém o caracter que está a uma posição a frente do ponteiro @current
    def next_ch
        @input[@current + 1]
    end

    # Verifica se o caracter que está a uma posição a frente do ponteiro possui um determinado valor
    def next_ch?(match)
        next_ch() == match
    end

    # Verifica se, a partir da posição do ponteiro, já alcançou-se o fim da cadeia de caracteres
    def ended?
        @current >= @input.length
    end

    # Verifica se determinado valor (string) é numérico
    def numeric?(value)
        value != nil && value >= "0" && value <= "9"
    end

    # Verifica se determinado valor é alfabético, incluindo o caracter _
    def alpha?(value)
        value != nil && (value == "_" || (value >= "a" && value <= "z") || (value >= "A" && value <= "Z"))
    end

    # Verifica se determinado valor é alfanumérico
    def alphanumeric?(value)
        numeric?(value) || alpha?(value)
    end

    # Adiciona um token à lista de tokens gerados como saída
    def add_token(token_type, lexeme = "")
        @tokens.push Token.new token_type, lexeme, @line, @column
    end

    # Avança sobre a entrada enquanto o valor apontado for numérico, ou o caracter '.', concatenando
    # esses valores em uma string. Ao fim do processo, adiciona um token à saída com esta string
    # como lexema
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

    # Avança sobre a entrada enquanto o valor apontado for alfanumérico, concatenando
    # esses valores em uma string. Ao fim do processo, adiciona um token à saída com esta 
    # string como lexema, com o tipo específico caso for uma palavra reservada
    def add_identifier
        _identifier = ""

        while (alphanumeric?(current()))
            _identifier += current()

            move_forward()
        end

        move_backwards()

        add_token(@reserved_keywords[_identifier] || :identifier, _identifier)
    end

    # Avança sobre a entrada enquanto o valor lido estiver entre um par de aspas,
    # concatenando estes valores, adicionando estes na lista de tokens, como
    # um valor literal de string
    def add_string
        _string = ""

        move_forward()

        while !current?("\"")
            if ended?
                @errors.push "String not terminated!"
                break
            end

            _string += current()
            move_forward()
        end

        add_token(:string, _string)
    end
end
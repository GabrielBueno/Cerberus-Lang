class Token
    def initialize(type_symbol, lexeme = "")
        @type_symbol = type_symbol
        @lexeme      = lexeme
    end

    def type
        return @type_symbol
    end

    def lexeme
        return @lexeme
    end
end
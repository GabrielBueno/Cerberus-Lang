class Token
    attr_accessor :type
    attr_accessor :lexeme

    def initialize(type, lexeme = "")
        @type   = type
        @lexeme = lexeme
    end
end
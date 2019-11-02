###
# -----------------------------------------
# Token
#
# Representa uma parte atômica da linguagem,
# possuindo um tipo, e um lexema específico,
# cuja utilidade depende do seu tipo
# -----------------------------------------
###
class Token
    attr_accessor :type
    attr_accessor :lexeme
    attr_accessor :line
    attr_accessor :column

    def initialize(type, lexeme = "", line=0, column=0)
        @type   = type
        @lexeme = lexeme
        @column = column
        @line   = line
    end

    def to_s
        lexeme
    end

    def type?(type)
        @type == type 
    end
end
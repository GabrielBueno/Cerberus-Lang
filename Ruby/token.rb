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

    def initialize(type, lexeme = "")
        @type   = type
        @lexeme = lexeme
    end
end
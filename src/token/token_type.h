namespace cerberus {
    /**
     * Define todos os possíveis tipos de Tokens 
     */
    enum TokenType {
        /* --- Pontuações --- */
        LEFT_PAREN, RIGHT_PAREN,                   // ()
        LEFT_CURLY_BRACE, RIGHT_CURLY_BRACE,       // {}
        LEFT_SQUARE_BRACKET, RIGHT_SQUARE_BRACKET, // []
        COMMA, DOT, SEMICOLON,                     // , . ;
        AMPERSAND, HASHTAG,                        // & #

        /* --- Operadores aritméticos --- */
        PLUS, MINUS, // + -
        SLASH, STAR, // / *

        /* --- Operadores lógicos --- */
        BANG, BANG_EQUAL,       // ! !=
        EQUAL, EQUAL_EQUAL,     // = ==
        GREATER, GREATER_EQUAL, // > >=
        LESS, LESS_EQUAL,       // < <=
        AND, OR, XOR,           // && || ^^

        /* --- Operadores bit a bit --- */
        BITWISE_AND, BITWISE_OR,  // & |
        BITWISE_XOR, BITWISE_NOT, // ^ ~
        LEFT_SHIFT,  RIGHT_SHIFT, // << >>

        /* --- Identificadores, cadeias de caracteres, e valores numéricos --- */
        IDENTIFIER, STRING, NUMBER,

        /* --- Palavras reservadas --- */
        TRUE, FALSE, // Valores lógicos
        NULL_VALUE,  // Valor nulo

        LET, CONST, FUNC, // Declaração de variáveis, constantes, ou funções
        IF, ELSE, ELIF,   // Estruturas de desvio condicional
        WHILE, FOR,       // Estruturas de laço condicional

        // Tipos de dados
        INT, UINT, DOUBLE, 
        BYTE, BOOL,
        CHAR, STRING_TYPE,
        I8, I16, I32,
        U8, U16, U32,
        VOID,

        // Estruturas de dados, e orientação a objetos
        STRUCT, CLASS, 
        SUPER, THIS, 
        NEW,

        END_OF_FILE, NO_TYPE
    };
}
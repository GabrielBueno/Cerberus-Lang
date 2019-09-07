#ifndef CERBERUS_LEXER_H_
#define CERBERUS_LEXER_H_

#include <vector>
#include <string>

#include "../token/token.h"

namespace cerberus {
    class Lexer {
    public:
        Lexer(std::string source);
        ~Lexer();

        /**
         * Recebe um determinado código como entrada, realiza a sua leitura,
         * e retorna uma lista com os tokens obtidos
         */
        std::vector<Token> tokenize();

    private:
        /**
         * Retorna e consome o caracter sendo lido atualmente
         */
        char move();

        /**
         * Retorna o caracter sendo lido atualmente, sem consumí-lo
         */
        char peek();

        /**
         * Verifica se o caracter sendo lido atualmente possui um valor específico
         */
        bool match(char expected);

        /**
         * Consome o caracter sendo lido atualmente, caso este possua um valor específico,
         * caso contrário, não avança na cadeia de caracteres.
         * 
         * Retorna o booleano que indica se o caracter possui ou não o valor específico
         */
        bool move_if_match(char expected);

        /**
         * Verifica se ainda há caracteres na entrada para serem lidos
         */
        bool ended();

        std::string _source;
        std::vector<Token> _tokens;
        
        size_t _source_size;
        unsigned int _current;
        unsigned int _line;
    };
}

#endif //CERBERUS_LEXER_H_
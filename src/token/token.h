#ifndef CERBERUS_TOKEN_H_
#define CERBERUS_TOKEN_H_

#include <string>

#include "token_type.h"

namespace Cerberus {
    class Token {
    public:
        /**
         * Construtor da classe.
         * 
         * Recebe como parâmetros o tipo do Token, e o valor deste (seu lexema)
         */
        Token(TokenType type, std::string lexeme);
        Token(TokenType type);

        /**
         * Destrutor da classe. Não realiza nenhuma operação
         */
        ~Token();

        /**
         * Especifica em qual linha este Token está no arquivo fonte. 
         * Esta informação servirá para um maior detalhe na exibição dos erros no código
         */
        void in_line(unsigned int line);

        /**
         * Especifica em qual coluna este Token está no arquivo fonte.
         * Esta informação servirá para um maior detalhe na exibição dos erros no código
         */
        void in_col(unsigned int col);

        /**
         * Obtém a linha onde este Token está no código fonte
         */
        unsigned int get_line();

        /**
         * Obtém a coluna onde este Token está no código fonte
         */
        unsigned int get_col();

        /**
         * Obtém o tipo deste Token
         */
        TokenType type();

        /**
         * Obtém o lexema (símbolo, valor) deste Token
         */
        std::string lexeme();

    private:
        TokenType _type;
        std::string _lexeme;
        unsigned int _line;
        unsigned int _col;
    };
}

#endif // CERBERUS_TOKEN_H_
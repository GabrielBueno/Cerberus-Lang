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
         * Caso a lista de tokens esteja vazia, realiza a leitura do código fonte para a obtenção
         * destes, e retorna a lista. Caso não esteja vazia, retorna a lista no estado em que está
         */
        std::vector<Token> tokens();

        /**
         * Limpa a lista de tokens, e faz todo o processo de leitura de tokens a partir do fonte
         * fornecido na construção da classe
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

        /**
         * Adiciona um Token na lista de tokens
         */
        Token add_token(TokenType tokenType);
        Token add_token(TokenType tokenType, std::string lexeme);

        /**
         * Limpa a lista de tokens
         */
        void clear_tokens();

        /**
         * Aumenta em 1 o contador de linhas do código fonte, e zera o contador de colunas
         */
        void newline();

        std::string _source;
        std::vector<Token> _tokens;
        
        size_t _source_size;
        unsigned int _current;
        unsigned int _line;
        unsigned int _col;
    };
}

#endif //CERBERUS_LEXER_H_
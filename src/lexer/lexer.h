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

        /**
         * Verifica se houveram erros no processo de scanning
         */
        bool has_errors();

        /**
         * Retorna a lista com as mensagens de erro ocorridas
         */
        std::vector<std::string> errors();

        /**
         * Exibe na saída os tokens lidos
         */
        void show_tokens();

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
         * Consome todos os caracteres da entrada, concatenando-os numa string, até encontrar um caracter
         * específico, sendo que este não será concatenado nem consumido.
         */
        std::string read_until_find(char expected);

        /**
         * Consome os caracteres da entrada enquanto os seus valores forem numéricos (inteiros ou decimais), e retorna a 
         * concatenação destes
         */
        std::string read_number();

        /**
         * Consome os caracteres da entrada enquanto os seus valores forem alfanuméricos,
         * 
         * Retorna o próprio Token que o define, indicando se este é um identificador ou uma palavra
         * reservada. No último caso, retorna o tipo exato do Token desta palavra reservada
         */
        Token read_identifier();

        /**
         * Verifica se ainda há caracteres na entrada para serem lidos
         */
        bool ended();

        /**
         * Adiciona um Token na lista de tokens
         */
        Token add_token(Token token);
        Token add_token(TokenType token_type);
        Token add_token(TokenType token_type, std::string lexeme);

        /**
         * Adiciona uma mensagem na lista de erros
         */
        void add_error(std::string error);
        void add_error(std::string error, bool show_line);
        void add_error(std::string error, bool show_line, bool show_column);

        /**
         * Limpa a lista de tokens
         */
        void clear_tokens();

        /**
         * Aumenta em 1 o contador de linhas do código fonte, e zera o contador de colunas
         */
        void newline();

        /**
         * Verifica se um determinado caracter é numérico
         */
        bool is_numeric(char chr);

        /**
         * Verifica se um determinado caracter é uma letra do alfabeto, incluindo o caracter _
         */
        bool is_alpha(char chr);

        /**
         * Verifica se um determinado caracter é alfanumérico, incluindo o caracter _
         */
        bool is_alphanumeric(char chr);

        std::string _source;
        std::vector<Token> _tokens;
        std::vector<std::string> _errors;
        
        size_t _source_size;
        unsigned int _current;
        unsigned int _line;
        unsigned int _col;
    };
}

#endif //CERBERUS_LEXER_H_
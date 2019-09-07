#include "lexer.h"

#include <cstdio>

namespace cerberus {
    Lexer::Lexer(std::string source) : 
        _source(source), 
        _source_size(source.size()),
        _current(0), 
        _line(1),
        _col(0)
    {
    }

    Lexer::~Lexer() {}

    /* --- Métodos públicos --- */
    std::vector<Token> Lexer::tokens() {
        if (_tokens.size() == 0)
            tokenize();

        return _tokens;
    }

    std::vector<Token> Lexer::tokenize() {
        clear_tokens();

        while (!ended()) {
            char current_character = move();

            switch (current_character) {
                case ' ':
                case '\t':
                case '\r':
                    break;

                case '\n': newline(); break;

                /* Pontuações */
                case '(': add_token(LEFT_PAREN);  break;
                case ')': add_token(RIGHT_PAREN); break;
                case '[': add_token(LEFT_SQUARE_BRACKET);  break;
                case ']': add_token(RIGHT_SQUARE_BRACKET); break;
                case '{': add_token(LEFT_CURLY_BRACE);     break;
                case '}': add_token(RIGHT_CURLY_BRACE);    break;
                case '.': add_token(DOT);       break;
                case ',': add_token(COMMA);     break;
                case ';': add_token(SEMICOLON); break;
                case '#': add_token(HASHTAG);   break;

                /* Operadores aritméticos */
                case '+': add_token(PLUS);      break;
                case '-': add_token(MINUS);     break;
                case '*': add_token(STAR);      break;
                case '/': add_token(SLASH);     break;

                /* Operadores lógicos/bit a bit */
                case '!':
                    move_if_match('=') ? add_token(NOT_EQUAL) : add_token(NOT);
                    break;

                case '=':
                    move_if_match('=') ? add_token(EQUAL_EQUAL) : add_token(EQUAL);
                    break;

                case '>':
                    if (match('=')) {
                        add_token(GREATER_EQUAL);
                        move();
                    } else if (match('>')) {
                        add_token(RIGHT_SHIFT);
                        move();
                    } else {
                        add_token(GREATER);
                    }

                    break;

                case '<':
                    if (match('=')) {
                        add_token(LESSER_EQUAL);
                        move();
                    } else if (match('<')) {
                        add_token(LEFT_SHIFT);
                        move();
                    } else {
                        add_token(LESSER);
                    }

                    break;

                case '&':
                    move_if_match('&') ? add_token(EQUAL_EQUAL) : add_token(BITWISE_AND);
                    break;

                case '|':
                    move_if_match('|') ? add_token(OR) : add_token(BITWISE_OR);
                    break;

                case '^':
                    move_if_match('^') ? add_token(XOR) : add_token(BITWISE_XOR);
                    break;

                case '~': add_token(BITWISE_NOT); break;

                /* Palavras reservadas */

                /* Identificadores, string, e números */

                default:
                    fprintf(stderr, "Unexpected %c in line %d column %d.\n\n", current_character, _line, _col);
            }
        }

        return _tokens;
    }

    /* --- Métodos privados --- */
    char Lexer::move() {
        if (ended())
            return '\0';

        _current += 1;
        _col     += 1;

        return _source.at(_current - 1);
    }

    char Lexer::peek() {
        if (ended())
            return '\0';

        return _source.at(_current);
    }

    bool Lexer::match(char expected) {
        return !ended() && peek() == expected;
    }

    bool Lexer::move_if_match(char expected) {
        bool matched = match(expected);

        if (matched) {
            _current += 1;
            _col     += 1;
        }

        return matched;
    }

    bool Lexer::ended() {
        return _current >= _source_size;
    }

    Token Lexer::add_token(TokenType type) {
        Token token = Token(type, nullptr);

        token.in_col(_col);
        token.in_line(_line);

        _tokens.push_back(token);

        return token;
    }

    Token Lexer::add_token(TokenType type, std::string lexeme) {
        Token token = Token(type, lexeme);

        token.in_col(_col);
        token.in_line(_line);

        _tokens.push_back(token);

        return token;
    }

    void Lexer::clear_tokens() {
        _tokens.clear();
    }

    void Lexer::newline() {
        _line += 1;
        _col   = 0;
    }
}
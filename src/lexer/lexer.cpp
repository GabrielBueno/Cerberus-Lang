#include "lexer.h"

#include <iostream>
#include <sstream>

#include "../token/token.h"
#include "../token/token_type.h"

namespace Cerberus {
    Lexer::Lexer(std::string input) : 
        _current_char(0), 
        _input(input),
        _tokens(std::make_unique<std::vector<Token>>())
    {
    }

    Lexer::~Lexer() {}

    std::unique_ptr<std::vector<Token>> Lexer::tokens() {
        tokenize_input();

        return std::move(_tokens);
    }

    void Lexer::tokenize_input() {
        _tokens = std::make_unique<std::vector<Token>>();

        while(!input_ended()) {
            switch (current()) {
                case ' ':
                case '\n':
                case '\r':
                case '\t':
                    break;

                case '+': add_token(PLUS,  "+"); break;
                case '-': add_token(MINUS, "-"); break;
                case '*': add_token(STAR,  "*"); break;
                case '/': add_token(SLASH, "/"); break;

                case '(': add_token(LEFT_PAREN,  "("); break;
                case ')': add_token(RIGHT_PAREN, ")"); break;

                default:
                    if (is_numeric(current()))
                        add_number();
                    else if (is_alpha(current()))
                        add_identifier();
                    else
                        std::cout << "Unexpected " << current() << " found\n";
            }

            consume();
        }
    }

    char Lexer::current() {
        return input_ended() ? '\0' : _input[_current_char];
    }

    char Lexer::previous() {
        if (_current_char == 0)
            return '\0';

        return _input[_current_char - 1];
    }

    char Lexer::next() {
        if (_current_char + 1 >= _input.length())
            return '\0';

        return _input[_current_char + 1];
    }

    char Lexer::consume() {
        if (input_ended())
            return '\0';

        char current_ch = current();
        _current_char += 1;

        return current_ch;
    }


    bool Lexer::current_is(char ch) {
        return current() == ch;
    }

    bool Lexer::previous_is(char ch) {
        return previous() == ch;
    }

    bool Lexer::next_is(char ch) {
        return next() == ch;
    }


    bool Lexer::is_alpha(char ch) {
        return ch == '_' || (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z');
    }

    bool Lexer::is_numeric(char ch) {
        return (ch >= '0' && ch <= '9');
    }

    bool Lexer::is_alphanumeric(char ch) {
        return is_alpha(ch) || is_numeric(ch);
    }

    bool Lexer::input_ended() {
        return _current_char >= _input.length();
    }


    void Lexer::add_number() {
        std::stringstream number;
        bool found_decimal = false;

        while (is_numeric(current()) || current_is('.')) {
            if (current_is('.') && !found_decimal) {
                found_decimal = true;
            }
            else if (current_is('.') && found_decimal) {
                std::cout << "Warning: number with two decimal separators!\n";
                break;
            }
            
            number << current();

            if (is_numeric(next()) || next_is('.'))
                consume();
            else
                break;
        }

        add_token(found_decimal ? DOUBLE_LITERAL : INTEGER_LITERAL, number.str());
    }

    void Lexer::add_identifier() {
        std::stringstream identifier;

        while (is_alphanumeric(current())) {
            identifier << current();

            if (is_alphanumeric(next()))
                consume();
            else
                break;
        }

        add_token(IDENTIFIER, identifier.str());
    }

    void Lexer::add_token(Token token) {
        _tokens->push_back(token);
    }

    void Lexer::add_token(TokenType type) {
        _tokens->push_back(Token(type, ""));
    }

    void Lexer::add_token(TokenType type, std::string lexeme) {
        _tokens->push_back(Token(type, lexeme));
    }
}
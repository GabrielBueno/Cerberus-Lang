#include "lexer.h"

#include <cstdio>
#include <sstream>

namespace cerberus {
    Lexer::Lexer(std::string source) : 
        _source(source), 
        _source_size(source.size()),
        _current(0), 
        _line(1),
        _col(0)
    {
        load_reserved_keywords();
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
            char current_ch = move();

            switch (current_ch) {
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

                case '"':
                    add_token(STRING_LITERAL, read_string());

                    // Consome o último "
                    move();
                    break;

                default:
                    // Valores numéricos
                    if (is_numeric(current_ch))
                        add_token(read_number(current_ch));
                    else if (is_alpha(current_ch))
                        add_token(read_identifier(current_ch));
                    else
                        fprintf(stderr, "Unexpected %c in line %d column %d.\n\n", current_ch, _line, _col);
            }
        }

        return _tokens;
    }

    bool Lexer::has_errors() {
        return !_errors.empty();
    }

    std::vector<std::string> Lexer::errors() {
        return _errors;
    }

    void Lexer::show_tokens() {
        for (unsigned int i = 0; i < _tokens.size(); i++) {
            Token token = _tokens.at(i);

            fprintf(stdout, "(%d, %s)\n", token.type(), token.lexeme().c_str());
        }
    }

    /* --- Métodos privados --- */

    char Lexer::move() {
        if (ended())
            return '\0';

        _current += 1;
        _col     += 1;

        //printf("Moving. Current: %d\n", _current);

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

    std::string Lexer::read_string() {
        std::stringstream result_sstream;

        for (char peeked_char = move(); peeked_char != '"'; peeked_char = move()) {
            if (ended()) {
                add_error("Unterminated string started", true);
                break;
            }

            result_sstream << peeked_char;
        }

        return result_sstream.str();
    }

    Token Lexer::read_number() {
        std::stringstream number_sstream;
        bool readed_decimal_separator = false;

        for (char peeked = peek(); is_numeric(peeked) || peeked == '.'; peeked = move()) {
            if (peeked == '.' && readed_decimal_separator) {
                add_error("Invalid decimal literal", true, true);
                break;
            }

            if (peeked == '.' && !readed_decimal_separator)
                readed_decimal_separator = true;

            number_sstream << peeked;
        }

        return readed_decimal_separator ? Token(DOUBLE_LITERAL, number_sstream.str()) : Token(INTEGER_LITERAL, number_sstream.str());
    }

    /**
     * Lê um número na entrada, adicionando algum digito que o precede no começo do 
     * lexema
     */
    Token Lexer::read_number(char preceded_digit) {
        Token number = read_number();

        return Token(number.type(), preceded_digit + number.lexeme());
    }

    Token Lexer::read_identifier(char preceded_by) {
        std::stringstream identifier_sstream;
        std::string identifier;

        identifier_sstream << preceded_by;

        for (char peeked = move(); is_alphanumeric(peeked); peeked = move()) { 
            identifier_sstream << peeked;

            //fprintf(stdout, "%c\n", peeked);
        }

        identifier = identifier_sstream.str();

        // Caso exista uma chave com o identifier obtido, dereferencia o ponteiro para o Token correspondente e o retorna.
        // Caso contrário, monta o Token com o identifier obtido
        return _reserved_keywords[identifier] ? *_reserved_keywords[identifier] : Token(IDENTIFIER, identifier);
    }

    bool Lexer::ended() {
        return _current >= _source_size;
    }

    Token Lexer::add_token(Token token) {
        token.in_col(_col);
        token.in_line(_line);

        _tokens.push_back(token);

        return token;
    }

    Token Lexer::add_token(TokenType type) {
        Token token = Token(type, "");

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

    bool Lexer::is_numeric(char ch) {
        return ch >= '0' && ch <= '9';
    }

    bool Lexer::is_alpha(char ch) {
        return ch == '_' || (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z');
    }

    bool Lexer::is_alphanumeric(char ch) {
        return is_alpha(ch) || is_numeric(ch);
    }

    void Lexer::add_error(std::string error) {
        std::stringstream sstream;

        sstream << "Error: " << error << "\n\n";

        _errors.push_back(sstream.str());
    }

    void Lexer::add_error(std::string error, bool show_line) {
        std::stringstream sstream;

        sstream << "Error: " << error;

        if (show_line)
            sstream << " in line " << _line;

        sstream << "\n\n";

        _errors.push_back(sstream.str());
    }

    void Lexer::add_error(std::string error, bool show_line, bool show_column) {
        std::stringstream sstream;

        sstream << error;

        if (show_line)
            sstream << " in line " << _line;

        if (show_column)
            sstream << " in column " << _col;

        sstream << "\n\n";

        _errors.push_back(sstream.str());
    }

    void Lexer::load_reserved_keywords() {
        _reserved_keywords["true"]   = std::make_unique<Token>(TRUE);
        _reserved_keywords["false"]  = std::make_unique<Token>(FALSE);
        _reserved_keywords["null"]   = std::make_unique<Token>(NULL_VALUE);

        _reserved_keywords["let"]    = std::make_unique<Token>(LET);
        _reserved_keywords["const"]  = std::make_unique<Token>(CONST);
        _reserved_keywords["func"]   = std::make_unique<Token>(FUNC);
        _reserved_keywords["if"]     = std::make_unique<Token>(IF);
        _reserved_keywords["else"]   = std::make_unique<Token>(ELSE);
        _reserved_keywords["elif"]   = std::make_unique<Token>(ELIF);
        _reserved_keywords["while"]  = std::make_unique<Token>(WHILE);
        _reserved_keywords["for"]    = std::make_unique<Token>(FOR);

        _reserved_keywords["int"]    = std::make_unique<Token>(INT);
        _reserved_keywords["uint"]   = std::make_unique<Token>(UINT);
        _reserved_keywords["double"] = std::make_unique<Token>(DOUBLE);
        _reserved_keywords["byte"]   = std::make_unique<Token>(BYTE);
        _reserved_keywords["bool"]   = std::make_unique<Token>(BOOL);
        _reserved_keywords["char"]   = std::make_unique<Token>(CHAR);
        _reserved_keywords["string"] = std::make_unique<Token>(STRING_TYPE);
        _reserved_keywords["i8"]     = std::make_unique<Token>(I8);
        _reserved_keywords["i16"]    = std::make_unique<Token>(I16);
        _reserved_keywords["i32"]    = std::make_unique<Token>(I32);
        _reserved_keywords["u8"]     = std::make_unique<Token>(U8);
        _reserved_keywords["u16"]    = std::make_unique<Token>(U16);
        _reserved_keywords["u32"]    = std::make_unique<Token>(U32);
        _reserved_keywords["void"]   = std::make_unique<Token>(VOID);

        _reserved_keywords["struct"] = std::make_unique<Token>(STRUCT);
        _reserved_keywords["class"]  = std::make_unique<Token>(CLASS);
        _reserved_keywords["super"]  = std::make_unique<Token>(SUPER);
        _reserved_keywords["this"]   = std::make_unique<Token>(THIS);
        _reserved_keywords["new"]    = std::make_unique<Token>(NEW);
    }
}
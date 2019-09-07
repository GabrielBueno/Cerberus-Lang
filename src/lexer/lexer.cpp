#include "lexer.h"

namespace cerberus {
    Lexer::Lexer(std::string source) : 
        _source(source), 
        _source_size(source.size()),
        _current(0), 
        _line(1)
    {
    }

    Lexer::~Lexer() {}

    /* Métodos públicos */
    std::vector<Token> Lexer::tokenize() {
        std::vector<Token> tmp;
        return tmp;
    }

    /* Métodos privados */
    char Lexer::move() {
        if (ended())
            return '\0';

        _current += 1;
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

        if (matched)
            _current += 1;

        return matched;
    }

    bool Lexer::ended() {
        return _current >= _source_size;
    }
}
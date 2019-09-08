#include "lexer/lexer.h"

int main(int argc, char **argv) {
    if (argc >= 2) {
        cerberus::Lexer lexer(argv[1]);

        lexer.tokenize();
        lexer.show_tokens();
    }

    return 0;
}
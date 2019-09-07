#include "lexer/lexer.h"

int main(int argc, char **argv) {
    cerberus::Lexer lexer("1 == 1");

    lexer.tokenize();
    
    lexer.show_tokens();

    return 0;
}
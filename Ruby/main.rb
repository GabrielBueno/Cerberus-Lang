require_relative "lexer.rb"
require_relative "expr.rb"
require_relative "stmt.rb"
require_relative "parser.rb"
require_relative "expr_visitor.rb"
require_relative "cerberus_utils.rb"

def test
    l = Lexer.new "let a = 6 + 5 * (1 + 5.6) / 5 > 1 + 2"

    Printer.print_tokens l.tokens

    parser = Parser.new l.tokens
    ast    = parser.parse

    puts ast.accept(AstPrinterVisitor.new)
end

def repl
    while true
        print ">> "

        input  = gets.chomp

        if input == "quit"
            puts "Bye.\n\n"
            break
        end

        lexer  = Lexer.new  input
        parser = Parser.new lexer.tokens
        ast    = parser.parse

        puts ast.accept(AstPrinterVisitor.new)
    end
end

def exec_arg
    return if not ARGV[0]

    puts ARGV

    lexer  = Lexer.new  ARGV[0]
    parser = Parser.new lexer.tokens
    ast    = parser.parse

    puts ast.accept(AstPrinterVisitor.new)
end

exec_arg

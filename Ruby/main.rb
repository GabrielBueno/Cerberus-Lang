require_relative "lexer.rb"
require_relative "expr.rb"
require_relative "stmt.rb"
require_relative "parser.rb"
require_relative "expr_visitor.rb"
require_relative "cerberus_machine.rb"
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
        input = gets.chomp

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

def exec_file
    return if not ARGV[0]

    file  = File.open(ARGV[0])
    lexer = Lexer.new file.read.chomp

    if (lexer.has_errors?)
        lexer.show_errors()

        return
    end

    # Printer.print_tokens lexer.tokens

    parser = Parser.new lexer.tokens
    ast    = parser.parse

    if (parser.has_errors?)
        parser.show_errors()

        return
    end

    # puts ast.accept(AstPrinterVisitor.new)

    machine = CerberusMachine.new ast
    machine.run()
end

if ARGV[0] 
    exec_file
else
    repl
end

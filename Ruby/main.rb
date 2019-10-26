require_relative "lexer.rb"
require_relative "expr.rb"
require_relative "stmt.rb"
require_relative "parser.rb"
require_relative "expr_visitor.rb"
require_relative "cerberus_utils.rb"

l = Lexer.new "let a = 6 + 5 * (1 + 5.6) / 5 > !1 + -2; let b = 5 + 9"

Printer.print_tokens l.tokens

parser = Parser.new l.tokens
ast    = parser.parse

puts ast.accept(AstPrinterVisitor.new)


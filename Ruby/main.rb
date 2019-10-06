require_relative "lexer.rb"
require_relative "expr.rb"
require_relative "parser.rb"
require_relative "expr_visitor.rb"
require_relative "cerberus_utils.rb"

l = Lexer.new "6 + 5 * (1 + 5.6) / 5"

Printer.print_tokens l.tokens

p = Parser.new l.tokens
expr = p.parse

puts expr.accept(PrintExprVisitor.new)
puts expr.accept(ExprEvaluator.new)


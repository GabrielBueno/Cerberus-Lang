require_relative "lexer.rb"
require_relative "parser.rb"
require_relative "cerberus_utils.rb"

l = Lexer.new "6 + 5 * 1 + 5.6 / 5"

l.tokens.each do |t|
    print "(" + t.type.to_s + ", " + t.lexeme + ")\n"
end

# p = Parser.new l.tokens
# print p.parse.accept(PrintExprVisitor.new)
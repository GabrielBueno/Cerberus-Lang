require_relative "lexer.rb"

l = Lexer.new "let a = 6 + 5 * (1 + 5.6) / 5;"

l.tokens.each do |t|
    print "(" + t.type.to_s + ", " + t.lexeme + ")\n"
end
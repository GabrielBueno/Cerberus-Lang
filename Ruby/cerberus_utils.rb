class AstPrinterVisitor < ExprVisitor
    def visit_binary(expr)
        "(#{expr.operator.lexeme} #{expr.left.accept(self)} #{expr.right.accept(self)})"
    end

    def visit_unary(expr)
        "(#{expr.operator.lexeme} #{expr.expression.accept(self)})"
    end

    def visit_grouping(expr)
        "(#{expr.expression.accept(self)})"
    end

    def visit_literal(expr)
        "#{expr.token.lexeme}"
    end

    def visit_assignment(stmt)
        "let #{stmt.identifier.lexeme} #{stmt.assignment_op.lexeme} #{stmt.expr.accept(self)}"
    end

    def visit_print(stmt)
        "print #{stmt.expr.accept(self)}"
    end

    def visit_if(stmt)
        _pretty = "if #{stmt.expr.accept(self)} then #{stmt.block.accept(self)}"

        if (stmt.has_elif?)
            stmt.elif_stmts.each { |stmt| _pretty += "\n" + stmt.accept(self) }
        end

        if (stmt.has_else?)
            _pretty += "\n#{stmt.else_stmt.accept(self)}"
        end

        _pretty
    end

    def visit_else(stmt)
        "else #{stmt.block.accept(self)}"
    end

    def visit_elif(stmt)
        "elif #{stmt.expr.accept(self)} then #{stmt.block.accept(self)}"
    end

    def visit_block(block)
        _pretty = "\n{\n"

        block.stmts.each { |stmt| _pretty += stmt.accept(self) + "\n" }

        _pretty += "}\n"

        _pretty
    end
end

class Printer
    def self.print_expr(expr)
        puts "Printing expression..."
        expr.accept(PrintExprVisitor.new)
        print "\n"
    end

    def self.print_tokens(tokens)
        puts "Printing tokens..."

        tokens.each do |t|
            puts "(#{t.type.to_s}, #{t.lexeme})"
        end

        print "\n"
    end
end
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
        "redecl #{stmt.identifier.lexeme} #{stmt.assignment_op.lexeme} #{stmt.expr.accept(self)}"
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

    def visit_expr(stmt)
        "expr #{stmt.expr.accept(self)}"
    end

    def visit_for(stmt)
        "for #{stmt.initial_statement.accept(self)} while #{stmt.expression.accept(self)} make #{stmt.loop_statement.accept(self)} with #{stmt.block.accept(self)}"
    end

    def visit_else(stmt)
        "else #{stmt.block.accept(self)}"
    end

    def visit_elif(stmt)
        "elif #{stmt.expr.accept(self)} then #{stmt.block.accept(self)}"
    end

    def visit_while(stmt)
        "while #{stmt.expr.accept(self)} do #{stmt.block.accept(self)}"
    end

    def visit_var_declaration(stmt)
        "let #{stmt.identifier.lexeme} type #{stmt.type.lexeme} mut #{stmt.mutable} with value #{stmt.expr.accept(self) if stmt.expr != nil}"
    end

    def visit_return(stmt)
        "returning #{stmt.expression.accept(self)}"
    end

    def visit_param_decl(stmt)
        "#{stmt.identifier} with type #{stmt.type}"
    end

    def visit_func(stmt)
        _output = "decl func #{stmt.identifier} returning #{stmt.return_type} with params\n\n"

        stmt.parameters.each { |param| _output += param.accept(self) + "\n" }

        _output += "\nwith block\n#{stmt.block.accept(self)}\n\n"

        _output
    end

    def visit_func_call(stmt)
        "func_call not implemented"
    end

    def visit_program(stmt)
        _output = "Program:\n\n"

        stmt.stmts.each { |stmt| _output += stmt.accept(self) + "\n" }

        _output += "\nprogram ended\n"

        _output
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
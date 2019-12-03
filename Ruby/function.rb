class FunctionMachine
    attr_accessor :identifier
    attr_accessor :parameters
    attr_accessor :return_type
    attr_accessor :block
    attr_accessor :has_returned
    attr_accessor :returned_val

    def copy
        FunctionMachine.new @identifier, @parameters, @return_type, @block
    end

    def initialize(identifier, parameters, return_type, block)
        @identifier    = identifier
        @parameters    = parameters
        @return_type   = return_type
        @block         = block
        @has_returned  = false
        @returned_val  = nil
    end

    def run(args, super_scope=nil)
        _program = ProgramStmt.new @block.stmts
        _machine = CerberusMachine.new _program, super_scope, self

        if @parameters.length != args.length
            puts "Número de argumentos passados para a função é inválido"
            exit
        end

        for i in 0..(args.length - 1) do
            _param = @parameters[i]

            _machine.memory[CerberusMachine.arg_var_decl_name(_param.identifier)] = args[i]
        end

        _machine.run()

        return @returned_val
    end

    def call_return(value)
        @has_returned = true
        @returned_val = value

        return value
    end

private
    def run_block(block)
        block_program = ProgramStmt.new block.stmts
        sub_scope     = CerberusMachine.new block_program, self, self 

        sub_scope.run()
    end
end
class Variable
    TYPES = [
        :u8, :u16, :u32,
        :i8, :i16, :i32,
        :int, :double, :string
    ]

    attr_accessor :identifier
    attr_accessor :mutable
    attr_accessor :type
    attr_accessor :value
    attr_accessor :error

    def self.from_token(token)
        _type  = nil
        _value = nil

        if token.type? :integer
            _type  = :i32
            _value = token.lexeme.to_i
        elsif token.type? :double
            _type = :double
            _value = token.lexeme.to_f
        elsif token.type? :string
            _type  = :string
            _value = token.lexeme
        else
            return nil
        end

        return Variable.constant _type.to_sym, _value
    end

    def self.constant(type, value)
        return Variable.new "_constant", false, type.to_sym, value
    end

    def initialize(identifier, mutable, type, value=nil)
        @identifier = identifier
        @mutable    = mutable
        @type       = type.to_sym
        @value      = value
        @error      = nil

        validate_type
    end

    def receive_variable(variable)
        @value = variable.value

        case @type
        when :u8
            validate_u8(variable)
        when :u16
            validate_u16(variable)
        when :u32
            validate_u32(variable)
        when :i8
            validate_i8(variable)
        when :i16
            validate_i16(variable)
        when :i32
            validate_i32(variable)
        when :double
            validate_double(variable)
        when :string
            validate_string(variable)
        end
    end

    def type?(type)
        @type == type
    end

    def has_error?
        @error != nil
    end

    def truthy?
        if type?(:string)
            return @value != nil && @value != ""
        end

        @value > 0
    end

    def to_s
        @value
    end

private
    def validate_type
        if !valid_type?
            set_error "Type '#{@type}' of variable '#{@identifier}' is not a valid type"
            return
        end

        @type = :i32 if @type == :int
    end

    def valid_type?
        TYPES.include? @type
    end

    def validate_u8(incoming)

        # Atribuindo string
        if incoming.type? :string
            set_error "Trying to assign a string '#{@value}' value to an u8 variable"
            return false
        end

        # Atribuindo double
        if incoming.type? :double
            set_error "Trying to assign a double '#{@value}' value to an 8 bit unsigned variable"
            return false
        end

        # Um inteiro menor do que zero
        if @value < 0
            set_error "Trying to assign a negative '#{@value}' value to an 8 bit unsigned variable"
            return false
        end

        # Um inteiro maior que o tamanho da variável
        if @value > 255
            set_error "Value '#{@value}' overflows the 8 bit size of the variable"
            return false
        end

        return true
    end

    def validate_u16(incoming)
        # Atribuindo string
        if incoming.type? :string
            set_error "Trying to assign a string '#{@value}' value to an u16 variable"
            return false
        end

        # Atribuindo double
        if incoming.type? :double
            set_error "Trying to assign a double '#{@value}' value to an 16 bit unsigned variable"
            return false
        end

        # Um inteiro menor do que zero
        if @value < 0
            set_error "Trying to assign a negative '#{@value}' value to an 16 bit unsigned variable"
            return false
        end

        # Um inteiro maior que o tamanho da variável
        if @value > 65535
            set_error "Value '#{@value}' overflows the 16 bit size of the variable"
            return false
        end

        return true
    end

    def validate_u32(incoming)
        # Atribuindo string
        if incoming.type? :string
            set_error "Trying to assign a string '#{@value}' value to an u32 variable"
            return false
        end

        # Atribuindo double
        if incoming.type? :double
            set_error "Trying to assign a double '#{@value}' value to an 32 bit unsigned variable"
            return false
        end

        # Um inteiro menor do que zero
        if @value < 0
            set_error "Trying to assign a negative '#{@value}' value to an 32 bit unsigned variable"
            return false
        end

        # Um inteiro maior que o tamanho da variável
        if @value > 4294967295
            set_error "Value '#{@value}' overflows the 32 bit size of the variable"
            return false
        end

        return true
    end

    def validate_i8(incoming)
        # Atribuindo string
        if incoming.type? :string
            set_error "Trying to assign a string '#{@value}' value to an i8 variable"
            return false
        end

        # Atribuindo double
        if incoming.type? :double
            set_error "Trying to assign a double '#{@value}' value to an 8 bit signed variable"
            return false
        end

        # Um inteiro maior ou menor que o tamanho máximo ou mínimo da variável
        if @value < -128 || @value > 255
            set_error "Value '#{@value}' overflows the 8 bit size of the variable"
            return false
        end

        return true
    end

    def validate_i16(incoming)
        # Atribuindo string
        if incoming.type? :string
            set_error "Trying to assign a string '#{@value}' value to an i16 variable"
            return false
        end

        # Atribuindo double
        if incoming.type? :double
            set_error "Trying to assign a double '#{@value}' value to an 16 bit signed variable"
            return false
        end

        # Um inteiro maior ou menor que o tamanho máximo ou mínimo da variável
        if @value < -32768 || @value > 32767
            set_error "Value '#{@value}' overflows the 16 bit size of the variable"
            return false
        end

        return true
    end

    def validate_i32(incoming)
        # Atribuindo string
        if incoming.type? :string
            set_error "Trying to assign a string '#{@value}' value to an i32 variable"
            return false
        end

        # Atribuindo double
        if incoming.type? :double
            set_error "Trying to assign a double '#{@value}' value to an 32 bit signed variable"
            return false
        end

        # Um inteiro maior ou menor que o tamanho máximo ou mínimo da variável
        if @value < -2147483648 || @value > 2147483647
            set_error "Value '#{@value}' overflows the 32 bit size of the variable"
            return false
        end

        return true
    end

    def validate_double(incoming)
        # Atribuindo string
        if incoming.type? :string
            set_error "Trying to assign a string '#{@value}' value to a double variable"
            return false
        end

        # Qualquer coisa que não seja um inteiro ou um double
        # if !incoming.type?(:integer) || !incoming.type?(:double)
        #     set_error "Trying to assign invalid '#{@value}' value to a double variable"
        #     return false
        # end

        # Um inteiro maior ou menor que o tamanho máximo ou mínimo da variável
        if @value < -9223372036854775808 || @value > 9223372036854775807
            set_error "Value '#{@value}' overflows the size of the double variable"
            return false
        end

        return true
    end

    def validate_string(incoming)
        # Qualquer coisa que não seja uma string
        if !incoming.type? :string
            set_error "Trying to assign an invalid '#{@value}' value to a string variable"
            return false
        end

        return true
    end

    def set_error(error)
        @error = error
    end
end
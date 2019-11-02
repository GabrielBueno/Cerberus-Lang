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
        if @value < −9223372036854775808 || @value > 9223372036854775807
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

class VariableHandler
    # Tabela de dominância
    DOMINANCE_TABLE = {
        :u8     => 1,
        :u16    => 2,
        :u32    => 3,
        :i8     => 4,
        :i16    => 5,
        :i32    => 6,
        :int    => 6,
        :double => 7,
        :string => 8
    }

    attr_accessor :error

    def initialize
        @error = nil
    end

    # Operações unárias
    def self.minus(variable)
        case variable.type
        when :u8, :i8
            return Variable.constant(:i8,  -variable.value)

        when :u16, :i16
            return Variable.constant(:i16, -variable.value)

        when :u32, :i32, :int
            return Variable.constant(:i32, -variable.value)

        when :double
            return Variable.constant(:double, -variable.value)

        when :string
            set_error "Could not apply unary '-' operation on string typed value"
        end
    end

    def self.not(variable)
        case variable.type
        when :u8, :i8
            return Variable.constant(:i8,  negate_value(variable.value))

        when :u16, :i16
            return Variable.constant(:i16, negate_value(variable.value))

        when :u32, :i32, :int
            return Variable.constant(:i32, negate_value(variable.value))

        when :double
            return Variable.constant(:double, negate_value(variable.value))

        when :string
            set_error "Could not apply unary '!' operation on string typed value"
        end
    end

    ### Operações binárias ###

    ### Soma
    def add(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        # Concatenação
        if (_dom_type == :string)
            return Variable.constant(:string, "#{first_variable.value}#{second_variable.value}")
        end

        # Caso contrário, soma algébrica
        return Variable.constant(_dom_type, first_variable.value + second_variable.value)
    end

    ### Subtração
    def sub(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        if (_dom_type == :string)
            set_error "Cannot subtract #{_sub_type.to_s} from #{_dom_type.to_s}"
            return nil
        end

        # Caso contrário, subtração algébrica
        return Variable.constant(_dom_type, first_variable.value - second_variable.value)
    end

    ### Multiplicação
    def mult(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        if (_dom_type == :string)
            set_error "Cannot multiply #{_sub_type.to_s} and #{_dom_type.to_s}"
            return nil
        end

        # Caso contrário, subtração algébrica
        return Variable.constant(_dom_type, first_variable.value * second_variable.value)
    end

    ### Divisão
    def div(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        if (_dom_type == :string)
            set_error "Cannote divide #{_sub_type.to_s} and #{_dom_type.to_s}"
            return nil
        end

        # Caso contrário, subtração algébrica
        return Variable.constant(_dom_type, first_variable.value / second_variable.value)
    end

    ### Igualdade
    def equal(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        if (_dom_type == :string)
            set_error "Cannot apply '==' operation between #{_sub_type.to_s} and #{_dom_type.to_s}"
            return nil
        end

        # Caso contrário, subtração algébrica
        return Variable.constant(:u8, equals?(first_variable.value, second_variable.value))
    end

    ### Diferente
    def not_equal(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        if (_dom_type == :string)
           set_error "Cannot apply '!=' operation between #{_sub_type.to_s} and #{_dom_type.to_s}"
            return nil
        end

        # Caso contrário, subtração algébrica
        return Variable.constant(:u8, not_equal?(first_variable.value, second_variable.value))
    end

    ### Maior
    def greater(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        if (_dom_type == :string)
            set_error "Cannot apply '>' operation between #{_sub_type.to_s} and #{_dom_type.to_s}"
            return nil
        end

        # Caso contrário, subtração algébrica
        return Variable.constant(:u8, greater?(first_variable.value, second_variable.value))
    end

    ### Maior ou igual
    def greater_equal(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        if (_dom_type == :string)
            set_error "Cannot apply '>=' operation between #{_sub_type.to_s} and #{_dom_type.to_s}"
            return nil
        end

        # Caso contrário, subtração algébrica
        return Variable.constant(:u8, greater_equal?(first_variable.value, second_variable.value))
    end

    ### Menor
    def lesser(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        if (_dom_type == :string)
            set_error "Cannot apply '<' operation between #{_sub_type.to_s} and #{_dom_type.to_s}"
            return nil
        end

        # Caso contrário, subtração algébrica
        return Variable.constant(:u8, lesser?(first_variable.value, second_variable.value))
    end

    ### Menor ou igual
    def lesser_equal(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        if (_dom_type == :string)
            set_error "Cannot apply '<=' operation between #{_sub_type.to_s} and #{_dom_type.to_s}"
            return nil
        end

        # Caso contrário, subtração algébrica
        return Variable.constant(:u8, lesser_equal?(first_variable.value, second_variable.value))
    end

    def had_error?
        return @error != nil
    end

private
    def set_error(error)
        @error = error
    end

    def negate_value(value)
        value > 0 ? 0 : value
    end

    def dominant_type(first_type, second_type)
        first_dominance  = DOMINANCE_TABLE[first_type]
        second_dominance = DOMINANCE_TABLE[second_type]

        first_dominance >= second_dominance ? first_type : second_type
    end

    def secondary_type(first_type, second_type)
        first_dominance  = DOMINANCE_TABLE[first_type]
        second_dominance = DOMINANCE_TABLE[second_type]

        first_dominance < second_dominance ? first_type : second_type
    end

    def equals?(val1, val2)
        val1 == val2 ? 1 : 0
    end 

    def not_equal?(val1, val2)
        val1 != val2 ? 1 : 0
    end

    def greater?(val1, val2)
        val1 > val2 ? 1 : 0
    end

    def greater_equal?(val1, val2)
        val1 >= val2 ? 1 : 0
    end

    def lesser?(val1, val2)
        val1 < val2 ? 1 : 0
    end

    def lesser_equal?(val1, val2)
        val1 <= val2 ? 1 : 0
    end
end
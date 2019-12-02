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
        _sub_type = secondary_type(first_variable.type, second_variable.type)

        if (_dom_type == :string && _sub_type != :string) || (_dom_type != :string &&_sub_type == :string)
            set_error "Cannot apply '==' operation between #{_sub_type.to_s} and #{_dom_type.to_s}"
            return nil
        end

        # Caso contrário, subtração algébrica
        return Variable.constant(:u8, equals?(first_variable.value, second_variable.value))
    end

    ### Diferente
    def not_equal(first_variable, second_variable)
        _dom_type = dominant_type(first_variable.type,  second_variable.type)

        if (_dom_type == :string && _sub_type != :string) || (_dom_type != :string &&_sub_type == :string)
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
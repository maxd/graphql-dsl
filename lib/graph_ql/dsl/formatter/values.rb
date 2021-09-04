# frozen_string_literal: true

module GraphQL
  module DSL
    class Formatter # rubocop:disable Style/Documentation
      private

      ##
      # Format value to string
      #
      # @param value [] value
      # @param is_const [Boolean] allow to use variables or not i.e. value is constant or not
      #
      # @return [String] representation of value as string
      def format_value(value, is_const) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
        case value
        when Integer
          format_value_to_integer(value)
        when Float
          format_value_to_float(value)
        when String
          format_value_to_string(value)
        when TrueClass, FalseClass
          format_value_to_boolean(value)
        when NilClass
          format_value_to_null(value)
        when Symbol
          if value.start_with?('$')
            format_value_to_variable(value, is_const)
          else
            format_value_to_enum(value)
          end
        when Array
          format_value_to_list(value, is_const)
        when Hash
          format_value_to_object(value, is_const)
        else
          raise Error.new('Unsupported value type', class: value.class.name, value: value)
        end
      end

      ##
      # Format value to integer value
      #
      # @param value [Integer] value
      #
      # @return [String] representation of value as integer value
      def format_value_to_integer(value)
        value.to_s
      end

      ##
      # Format value to float value
      #
      # @param value [Float] value
      #
      # @return [String] representation of value as float value
      def format_value_to_float(value)
        value.to_s
      end

      ##
      # Format value to string value
      #
      # @param value [String] value
      #
      # @return [String] representation of value as string value
      def format_value_to_string(value)
        value.dump
      end

      ##
      # Format value to boolean value
      #
      # @param value [TrueClass, FalseClass] value
      #
      # @return [String] representation of value as boolean value
      def format_value_to_boolean(value)
        value.to_s
      end

      ##
      # Format value to null value
      #
      # @param _value [NilClass] value
      #
      # @return [String] representation of value as null value
      def format_value_to_null(_value)
        'null'
      end

      ##
      # Format value to variable value
      #
      # @param value [Symbol] value
      # @param is_const [Boolean] allow to use variables or not
      #
      # @return [String] representation of value as variable value
      def format_value_to_variable(value, is_const)
        raise Error.new('Value must be constant', value: value) if is_const

        value.to_s
      end

      ##
      # Format value to enum value
      #
      # @param value [Symbol] value
      #
      # @return [String] representation of value as enum value
      def format_value_to_enum(value)
        value.to_s
      end

      ##
      # Format value to list value
      #
      # @param value [Array] value
      # @param is_const [Boolean] allow to use variables or not
      #
      # @return [String] representation of value as list value
      def format_value_to_list(value, is_const)
        result = value.map do |element|
          format_value(element, is_const)
        end.join(', ')

        "[#{result}]"
      end

      ##
      # Format value to object value
      #
      # @param value [Hash] value
      # @param is_const [Boolean] allow to use variables or not
      #
      # @return [String] representation of value as object value
      def format_value_to_object(value, is_const)
        result = value.map do |n, v|
          "#{n}: #{format_value(v, is_const)}"
        end.join(', ')

        "{#{result}}"
      end
    end
  end
end

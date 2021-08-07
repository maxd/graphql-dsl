# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      module Mixins
        ##
        # This mixin help to reuse values
        module Values
          private

          ##
          # Convert value to string
          #
          # @param value [] value
          #
          # @return [String] representation of value as string
          def __value_to_s(value) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
            case value
            when Integer
              __value_to_integer(value)
            when Float
              __value_to_float(value)
            when String
              __value_to_string(value)
            when TrueClass, FalseClass
              __value_to_boolean(value)
            when NilClass
              __value_to_null(value)
            when Symbol
              if value.start_with?('$')
                __value_to_variable(value)
              else
                __value_to_enum(value)
              end
            when Array
              __value_to_list(value)
            when Hash
              __value_to_object(value)
            else
              raise GraphQL::DSL::Error.new('Unsupported value type', class: value.class.name, value: value)
            end
          end

          ##
          # Convert value to integer value
          #
          # @param value [Integer] value
          #
          # @return [String] representation of value as integer value
          def __value_to_integer(value)
            value.to_s
          end

          ##
          # Convert value to float value
          #
          # @param value [Float] value
          #
          # @return [String] representation of value as float value
          def __value_to_float(value)
            value.to_s
          end

          ##
          # Convert value to string value
          #
          # @param value [String] value
          #
          # @return [String] representation of value as string value
          def __value_to_string(value)
            value.dump
          end

          ##
          # Convert value to boolean value
          #
          # @param value [TrueClass, FalseClass] value
          #
          # @return [String] representation of value as boolean value
          def __value_to_boolean(value)
            value.to_s
          end

          ##
          # Convert value to null value
          #
          # @param _value [NilClass] value
          #
          # @return [String] representation of value as null value
          def __value_to_null(_value)
            'null'
          end

          ##
          # Convert value to variable value
          #
          # @param value [Symbol] value
          #
          # @return [String] representation of value as variable value
          def __value_to_variable(value)
            value.to_s
          end

          ##
          # Convert value to enum value
          #
          # @param value [Symbol] value
          #
          # @return [String] representation of value as enum value
          def __value_to_enum(value)
            value.to_s
          end

          ##
          # Convert value to list value
          #
          # @param value [Array] value
          #
          # @return [String] representation of value as list value
          def __value_to_list(value)
            result = value.map do |element|
              __value_to_s(element)
            end.join(', ')

            "[#{result}]"
          end

          ##
          # Convert value to object value
          #
          # @param value [Hash] value
          #
          # @return [String] representation of value as object value
          def __value_to_object(value)
            result = value.map do |n, v|
              "#{n}: #{__value_to_s(v)}"
            end.join(', ')

            "{#{result}}"
          end
        end
      end
    end
  end
end

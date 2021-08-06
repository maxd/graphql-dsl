# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      module Mixins
        ##
        # This mixin help to reuse arguments
        module Arguments
          private

          ##
          # Convert field arguments to field signature of hash
          #
          # @param arguments [] field arguments
          # @param initial [Boolean] specify first call of this method or not
          #
          # @return [String] representation of arguments as string
          def __arguments_to_s(arguments, initial: false) # rubocop:disable Metrics/MethodLength
            case arguments
            when Hash
              __arguments_to_hash(arguments, initial)
            when Array
              __arguments_to_array(arguments)
            when String
              __arguments_to_string(arguments)
            when Symbol
              __arguments_to_enum(arguments)
            when NilClass
              'null'
            else
              arguments.to_s
            end
          end

          ##
          # Convert arguments to hash
          #
          # @param arguments [Hash] arguments
          # @param initial [Boolean] specify first call of this method or not
          #
          # @return [String] representation of arguments as string
          def __arguments_to_hash(arguments, initial)
            result = arguments.map do |name, value|
              "#{name}: #{__arguments_to_s(value)}"
            end.join(', ')

            initial ? "(#{result})" : "{#{result}}"
          end

          ##
          # Convert arguments to array
          #
          # @param arguments [Array] arguments
          #
          # @return [String] representation of arguments as string
          def __arguments_to_array(arguments)
            result = arguments.map do |argument|
              __arguments_to_s(argument)
            end.join(', ')

            "[#{result}]"
          end

          ##
          # Convert arguments to string
          #
          # @param arguments [String] arguments
          #
          # @return [String] representation of arguments as string
          def __arguments_to_string(arguments)
            %("#{arguments}")
          end

          ##
          # Convert arguments to enum
          #
          # @param arguments [Symbol] arguments
          #
          # @return [String] representation of arguments as enum
          def __arguments_to_enum(arguments)
            arguments.to_s
          end
        end
      end
    end
  end
end

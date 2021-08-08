# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      module Mixins
        ##
        # This mixin help to reuse arguments
        module Arguments
          include Mixins::Values

          private

          ##
          # Convert field arguments to field signature
          #
          # @param arguments [Hash] field arguments
          # @param is_const [Boolean] allow to use variables or not
          #
          # @return [String] representation of arguments as string
          def __arguments_to_s(arguments, is_const)
            return '' if arguments.empty?

            result = arguments.map do |name, value|
              "#{name}: #{__value_to_s(value, is_const)}"
            end

            "(#{result.join(', ')})"
          end
        end
      end
    end
  end
end

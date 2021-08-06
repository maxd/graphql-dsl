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
          #
          # @return [String] representation of arguments as string
          def __arguments_to_s(arguments)
            return '' if arguments.empty?

            result = arguments.map do |name, value|
              "#{name}: #{__value_to_s(value)}"
            end

            "(#{result.join(', ')})"
          end
        end
      end
    end
  end
end

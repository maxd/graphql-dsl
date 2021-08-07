# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Operation GraphQL node
      class Operation < Node
        include Mixins::VariableDefinitions
        include Mixins::Fields

        ##
        # @return [Symbol] operation type (see {#initialize})
        attr_reader :__operation_type

        ##
        # @return [Hash] variable definitions
        attr_reader :__variable_definitions

        ##
        # Create operation (query, mutation, subscription)
        #
        # @param operation_type [Symbol] operation type
        # @option operation_type [Symbol] :query query operation
        # @option operation_type [Symbol] :mutation mutation operation
        # @option operation_type [Symbol] :subscription subscription operation
        # @param name [String, Symbol, nil] operation name
        # @param variable_definitions [Hash] variable definitions
        # @param block [Proc] declare DSL for sub-fields
        def initialize(operation_type, name = nil, **variable_definitions, &block)
          super(name, &block)

          @__operation_type = operation_type
          @__variable_definitions = variable_definitions
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0)
          result = []

          operation_definition = __operation_definition_to_s

          result << __indent(level) + operation_definition if operation_definition
          result << "#{__indent(level)}{"
          result += __nodes.map { |node| node.to_gql(level + 1) }
          result << "#{__indent(level)}}"

          result.join("\n")
        end

        private

        ##
        # Build operation definition
        #
        # @return [String, nil] representation of operation definition as string
        def __operation_definition_to_s
          operation_name = [__operation_type_to_s, __name].compact

          operation_signature = [
            operation_name.empty? ? nil : operation_name.join(' '),
            __variable_definitions_to_s(__variable_definitions)
          ].compact

          operation_signature.empty? ? nil : operation_signature.join
        end

        ##
        # Build operation type
        #
        # @return [String, nil] representation of operation type as string
        def __operation_type_to_s
          __operation_type.to_s if __operation_type != :query || __name || !__variable_definitions.empty?
        end
      end
    end
  end
end

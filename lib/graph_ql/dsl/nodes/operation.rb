# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Operation GraphQL node
      class Operation < Node
        include Mixins::Fields

        ##
        # @return [Symbol] operation type (see {#initialize})
        attr_reader :__operation_type

        ##
        # Create operation (query, mutation, subscription)
        #
        # @param operation_type [Symbol] operation type
        # @option operation_type [Symbol] :query query operation
        # @option operation_type [Symbol] :mutation mutation operation
        # @option operation_type [Symbol] :subscription subscription operation
        # @param name [String, Symbol, nil] operation name
        # @param block [Proc] declare DSL for sub-fields
        def initialize(operation_type, name = nil, &block)
          super(name, &block)

          @__operation_type = operation_type
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0)
          result = []

          operation_definition = to_gql_operation_definition

          result << __indent(level) + operation_definition if operation_definition
          result << "#{__indent(level)}{"
          result += __nodes.map { |node| node.to_gql(level + 1) }
          result << "#{__indent(level)}}"

          result.join("\n")
        end

        private

        def to_gql_operation_definition
          if __operation_type == :query
            __name ? "#{__operation_type} #{__name}" : nil
          else
            __operation_type.to_s + (__name ? " #{__name}" : '')
          end
        end
      end
    end
  end
end

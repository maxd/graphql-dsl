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

          result << __indent(level) + "#{__operation_type} #{__name}" if __name
          result << "#{__indent(level)}{"
          result += __nodes.map { |node| node.to_gql(level + 1) }
          result << "#{__indent(level)}}"

          result.join("\n")
        end
      end
    end
  end
end

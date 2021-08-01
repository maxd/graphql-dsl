# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Query operation GraphQL node
      class QueryOperation < Node
        ##
        # @!parse [include] Fields
        include Fields

        ##
        # Create query operation
        #
        # @param name [String, Symbol, nil] query name
        # @param block [Proc] declare DSL for sub-fields
        def initialize(name = nil, &block)
          super
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0)
          result = []

          result << __indent(level) + "query #{__name}" if __name
          result << "#{__indent(level)}{"
          result += __nodes.map { |node| node.to_gql(level + 1) }
          result << "#{__indent(level)}}"

          result.join("\n")
        end
      end
    end
  end
end

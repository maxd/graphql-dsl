# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # @abstract Base class for all GraphQL DSL nodes
    class Node
      ##
      # @return [String, Symbol, nil] node name
      attr_reader :__name

      # @return [Array<Node>] list of sub-nodes
      attr_reader :__nodes

      ##
      # Create node
      #
      # @param name [String, Symbol, nil] node name
      # @param block [Proc] declare  DSL for sub-nodes
      def initialize(name = nil, &block)
        @__name = name
        @__nodes = []

        instance_eval(&block) if block
      end

      ##
      # Generate GraphQL query
      #
      # @param level [Integer] indent level
      # @param formatter [Formatter] GraphQL query formatter
      #
      # @return [String] GraphQL query string
      def to_gql(level = 0, formatter = Formatter.new)
        formatter.format_node(self, level)
      end
    end
  end
end

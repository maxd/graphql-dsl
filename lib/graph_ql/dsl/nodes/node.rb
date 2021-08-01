# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # @abstract Base class for all GraphQL DSL nodes
      class Node
        ##
        # @return [String, Symbol] node name
        attr_reader :__name

        # @return [Array<Node>] list of sub-nodes
        attr_reader :__nodes

        ##
        # Create node
        #
        # @param name [String, Symbol] node name
        # @param block [Proc] declare  DSL for sub-nodes
        def initialize(name, &block)
          @__name = name
          @__nodes = []

          instance_eval(&block) if block
        end

        ##
        # Generate GraphQL query
        #
        # @param level [Integer] indent level
        #
        # @return [String] GraphQL query string
        def to_gql(level = 0)
          raise NotImplementedError
        end

        protected

        ##
        # Generate indent for formatting
        #
        # @param level [Integer] indent level
        #
        # @return [String] string for indent
        def __indent(level)
          '  ' * level
        end
      end
    end
  end
end

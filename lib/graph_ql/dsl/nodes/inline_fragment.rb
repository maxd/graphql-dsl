# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Inline fragment GraphQL node
      class InlineFragment < Node
        include Mixins::SelectionSets

        ##
        # @return [String, Symbol, nil] inline fragment type or interface
        attr_reader :__type

        ##
        # @return [Array<GraphQL::DSL::Nodes::Containers::Directive>] list of directives
        attr_reader :__directives

        ##
        # Create inline fragment
        #
        # @param type [String, Symbol, nil] fragment type
        # @param directives [Array<Hash, Array, GraphQL::DSL::Nodes::Containers::Directive>] list of directives
        # @param block [Proc] declare DSL for sub-fields
        def initialize(type = nil, directives = [], &block)
          raise GraphQL::DSL::Error, 'Sub-fields must be specified for inline fragment' if block.nil?

          @__type = type
          @__directives = directives.map { |directive| Containers::Directive.from(directive) }

          super(nil, &block)
        end
      end
    end
  end
end

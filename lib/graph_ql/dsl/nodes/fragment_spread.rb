# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Fragment spread GraphQL node
      class FragmentSpread < Node
        ##
        # @return [Array<GraphQL::DSL::Nodes::Containers::Directive>] list of directives
        attr_reader :__directives

        ##
        # Create fragment spread
        #
        # @param name [String, Symbol] fragment name
        # @param directives [Array<Hash, Array, GraphQL::DSL::Nodes::Containers::Directive>] list of directives
        def initialize(name, directives = [])
          @__directives = directives.map { |directive| Containers::Directive.from(directive) }

          super(name)
        end
      end
    end
  end
end

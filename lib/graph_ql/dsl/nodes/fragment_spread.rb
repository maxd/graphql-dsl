# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Fragment spread GraphQL node
      class FragmentSpread < Node
        ##
        # @return [Array] list of directives
        attr_reader :__directives

        ##
        # Create fragment spread
        #
        # @param name [String, Symbol] fragment name
        # @param directives [Array] list of directives
        def initialize(name, directives = [])
          @__directives = directives

          super(name)
        end
      end
    end
  end
end

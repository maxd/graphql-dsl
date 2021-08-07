# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Fragment spread GraphQL node
      class FragmentSpread < Node
        ##
        # Create fragment spread
        #
        # @param name [String, Symbol] fragment name
        def initialize(name) # rubocop:disable Lint/UselessMethodDefinition
          super(name)
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0)
          __indent(level) + "...#{__name}"
        end
      end
    end
  end
end

# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Field GraphQL node
      class Field < Node
        include Mixins::SelectionSet

        ##
        # @return [String, Symbol, nil] field alias
        attr_reader :__alias

        ##
        # @return [Hash] list of filed arguments
        attr_reader :__arguments

        ##
        # @return [Array<GraphQL::DSL::Nodes::Containers::Directive>] list of directives
        attr_reader :__directives

        ##
        # Create field
        #
        # @param field_name [String, Symbol] field name
        # @param field_alias [String, Symbol, nil] field alias
        # @param arguments [Hash] field arguments
        # @param directives [Array<Hash, Array, GraphQL::DSL::Nodes::Containers::Directive>] list of directives
        # @param block [Proc] declare DSL for sub-fields
        def initialize(field_name, field_alias = nil, arguments = {}, directives = [], &block)
          @__alias = field_alias
          @__arguments = arguments
          @__directives = directives.map { |directive| Containers::Directive.from(directive) }

          super(field_name, &block)
        end
      end
    end
  end
end

# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # Field GraphQL node
    class Field < Node
      include SelectionSet

      ##
      # @return [String, Symbol, nil] field alias
      attr_reader :__alias

      ##
      # @return [Hash] list of filed arguments
      attr_reader :__arguments

      ##
      # @return [Array<Directive>] list of directives
      attr_reader :__directives

      ##
      # Create field
      #
      # @param field_name [String, Symbol] field name
      # @param field_alias [String, Symbol, nil] field alias
      # @param arguments [Hash] field arguments
      # @param directives [Array<Directive, Hash, Array>] list of directives
      # @param block [Proc] declare DSL for sub-fields
      def initialize(field_name, field_alias = nil, arguments = {}, directives = [], &block)
        @__alias = field_alias
        @__arguments = arguments
        @__directives = directives.map { |directive| Directive.from(directive) }

        super(field_name, &block)
      end
    end
  end
end

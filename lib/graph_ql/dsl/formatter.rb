# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # Format nodes to GraphQL
    class Formatter
      ##
      # Format node to GraphQL
      #
      # @param node [Node] node
      # @param level [Integer] indent level
      #
      # @return [String] representation of node as GraphQL string
      def format_node(node, level)
        case node
        when Nodes::ExecutableDocument then format_executable_document(node, level)
        when Nodes::Operation then format_operation(node, level)
        when Nodes::FragmentOperation then format_fragment_operation(node, level)
        when Nodes::Field then format_field(node, level)
        when Nodes::FragmentSpread then format_fragment_spread(node, level)
        when Nodes::InlineFragment then format_inline_fragment(node, level)
        else
          raise GraphQL::DSL::Error.new('Unknown node', class: node.class.name)
        end
      end

      private

      ##
      # Generate indent for formatting
      #
      # @param level [Integer] indent level
      #
      # @return [String] string for indent
      def indent(level)
        '  ' * level
      end
    end
  end
end

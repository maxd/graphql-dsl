# frozen_string_literal: true

module GraphQL
  module DSL
    class Formatter # rubocop:disable Style/Documentation
      private

      ##
      # Format inline fragment as string
      #
      # @param inline_fragment [InlineFragment] inline fragment node
      # @param level [Integer] indent level
      #
      # @return [String] representation of inline fragment as string
      def format_inline_fragment(inline_fragment, level)
        result = []
        result << indent(level) + format_inline_fragment_signature(inline_fragment)

        unless inline_fragment.__nodes.empty?
          result << "#{indent(level)}{"
          result += inline_fragment.__nodes.map { |node| format_node(node, level + 1) }
          result << "#{indent(level)}}"
        end

        result.join("\n")
      end

      ##
      # Format inline fragment signature as string
      #
      # @param inline_fragment [InlineFragment] inline fragment node
      #
      # @return [String] representation of inline fragment signature as string
      def format_inline_fragment_signature(inline_fragment)
        [
          '...',
          (inline_fragment.__type ? "on #{inline_fragment.__type}" : nil),
          format_directives(inline_fragment.__directives, false),
        ].compact.join(' ')
      end
    end
  end
end

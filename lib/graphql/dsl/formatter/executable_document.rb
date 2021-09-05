# frozen_string_literal: true

module GraphQL
  module DSL
    class Formatter # rubocop:disable Style/Documentation
      private

      ##
      # Format executable document as string
      #
      # @param executable_document [ExecutableDocument] executable document node
      # @param level [Integer] indent level
      #
      # @return [String] representation of executable document as string
      def format_executable_document(executable_document, level)
        result = []
        result += executable_document.__nodes.map { |node| format_node(node, level) }
        result.join("\n\n")
      end
    end
  end
end

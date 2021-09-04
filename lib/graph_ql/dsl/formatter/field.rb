# frozen_string_literal: true

module GraphQL
  module DSL
    class Formatter # rubocop:disable Style/Documentation
      private

      ##
      # Format field as string
      #
      # @param field [Field] field node
      # @param level [Integer] indent level
      #
      # @return [String] representation of field as string
      def format_field(field, level)
        result = []
        result << indent(level) + format_field_signature(field)

        unless field.__nodes.empty?
          result << "#{indent(level)}{"
          result += field.__nodes.map { |node| format_node(node, level + 1) }
          result << "#{indent(level)}}"
        end

        result.join("\n")
      end

      ##
      # Format field signature as string
      #
      # @param field [Field] field node
      #
      # @return [String] representation of field signature as string
      def format_field_signature(field)
        field_alias = field.__alias ? "#{field.__alias}: " : ''
        field_name = field.__name.to_s
        field_arguments = field.__arguments.empty? ? '' : format_arguments(field.__arguments, false)
        field_directives = field.__directives.empty? ? '' : " #{format_directives(field.__directives, false)}"

        [
          field_alias,
          field_name,
          field_arguments,
          field_directives,
        ].join
      end
    end
  end
end

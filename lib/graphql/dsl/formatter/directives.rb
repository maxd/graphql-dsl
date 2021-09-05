# frozen_string_literal: true

module GraphQL
  module DSL
    class Formatter # rubocop:disable Style/Documentation
      private

      ##
      # Format directives to string
      #
      # @param directives [Array] directives
      # @param is_const [Boolean] allow to use variables or not
      #
      # @return [String] representation of directives as string
      def format_directives(directives, is_const)
        return nil if directives.empty?

        result = directives.map do |directive|
          format_directive(directive, is_const)
        end

        result.join(' ')
      end

      ##
      # Format directive to string
      #
      # @param directive [] directive
      # @param is_const [Boolean] allow to use variables or not
      #
      # @return [String] representation of directive as string
      def format_directive(directive, is_const)
        result = []

        result << format_directive_name(directive.name)
        result << format_arguments(directive.arguments, is_const) unless directive.arguments.empty?

        result.compact.join
      end

      ##
      # Format directive name to string
      #
      # @param name [String] directive name
      #
      # @return [String] representation of directive name as string
      def format_directive_name(name)
        name.start_with?('@') ? name.to_s : "@#{name}"
      end
    end
  end
end

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
        case directive
        when Hash
          format_directive_from_hash(directive, is_const)
        when Array
          format_directive_from_array(directive, is_const)
        else
          raise GraphQL::DSL::Error.new('Unsupported directive type',
            class: directive.class.name, directive: directive)
        end
      end

      ##
      # Format directive to string
      #
      # @param directive [Hash] directive
      # @param is_const [Boolean] allow to use variables or not
      #
      # @return [String] representation of directive as string
      def format_directive_from_hash(directive, is_const)
        name = directive[:name]
        arguments = directive[:args]

        raise GraphQL::DSL::Error, 'Directive name must be specified' if name.nil? || name.empty?

        result = []

        result << format_directive_name(name)
        result << format_arguments(arguments, is_const) if directive.key?(:args)

        result.compact.join
      end

      ##
      # Format directive to string
      #
      # @param directive [Array] directive
      # @param is_const [Boolean] allow to use variables or not
      #
      # @return [String] representation of directive as string
      def format_directive_from_array(directive, is_const)
        name = directive[0]
        arguments = directive[1]

        raise GraphQL::DSL::Error, 'Directive name must be specified' if name.nil? || name.empty?

        result = []

        result << format_directive_name(name)
        result << format_arguments(arguments, is_const) if directive.size > 1

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

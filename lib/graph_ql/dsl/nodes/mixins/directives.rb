# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      module Mixins
        ##
        # This mixin help to reuse directives
        module Directives
          include Mixins::Arguments

          private

          ##
          # Convert directives to string
          #
          # @param directives [Array] directives
          # @param is_const [Boolean] allow to use variables or not
          #
          # @return [String] representation of directives as string
          def __directives_to_s(directives, is_const)
            return nil if directives.empty?

            result = directives.map do |directive|
              __directive_to_s(directive, is_const)
            end

            result.join(' ')
          end

          ##
          # Convert directive to string
          #
          # @param directive [] directive
          # @param is_const [Boolean] allow to use variables or not
          #
          # @return [String] representation of directive as string
          def __directive_to_s(directive, is_const)
            case directive
            when Hash
              __directive_as_hash_to_s(directive, is_const)
            when Array
              __directive_as_array_to_s(directive, is_const)
            else
              raise GraphQL::DSL::Error.new('Unsupported directive type',
                class: directive.class.name, directive: directive)
            end
          end

          ##
          # Convert directive to string
          #
          # @param directive [Hash] directive
          # @param is_const [Boolean] allow to use variables or not
          #
          # @return [String] representation of directive as string
          def __directive_as_hash_to_s(directive, is_const)
            name = directive[:name]
            arguments = directive[:args]

            raise GraphQL::DSL::Error, 'Directive name must be specified' if name.nil? || name.empty?

            result = []

            result << __directive_name_to_s(name)
            result << __arguments_to_s(arguments, is_const) if directive.key?(:args)

            result.compact.join
          end

          ##
          # Convert directive to string
          #
          # @param directive [Array] directive
          # @param is_const [Boolean] allow to use variables or not
          #
          # @return [String] representation of directive as string
          def __directive_as_array_to_s(directive, is_const)
            name = directive[0]
            arguments = directive[1]

            raise GraphQL::DSL::Error, 'Directive name must be specified' if name.nil? || name.empty?

            result = []

            result << __directive_name_to_s(name)
            result << __arguments_to_s(arguments, is_const) if directive.size > 1

            result.compact.join
          end

          ##
          # Convert directive name to string
          #
          # @param name [String] directive name
          #
          # @return [String] representation of directive name as string
          def __directive_name_to_s(name)
            name.start_with?('@') ? name.to_s : "@#{name}"
          end
        end
      end
    end
  end
end

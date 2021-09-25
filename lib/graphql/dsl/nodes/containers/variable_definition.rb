# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # Container for variable definition
    class VariableDefinition
      ##
      # @return [String, Symbol, nil] variable type
      attr_reader :type

      ##
      # @return [Object, nil] default value of variable
      attr_reader :default

      ##
      # @return [Array<Directive>] list of directives
      attr_reader :directives

      ##
      # Create variable definition container
      #
      # @param type [String, Symbol] variable type
      # @param default [Object, nil] default value
      # @param directives [Array<Directive, Hash, Array>] list of directives
      def initialize(type, default = UNDEFINED, directives = [])
        raise Error, 'Variable type must be specified' if type.nil? || type.empty?

        @type = type
        @default = default
        @directives = directives.map { |directive| Directive.from(directive) }
      end

      class << self
        ##
        # Create variable definition container from argument value
        #
        # @param value [] argument value
        #
        # @return [VariableDefinition] variable definition container
        def from(value)
          case value
          when VariableDefinition then value
          when Symbol, String then new(value)
          else
            raise Error.new('Unsupported format of variable definition', class: value.class.name, value: value)
          end
        end
      end
    end
  end
end

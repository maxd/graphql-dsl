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
        # Create variable definition container from Hash, Array or VariableDefinition
        #
        # @param value [VariableDefinition, Hash, Array] Hash, Array or VariableDefinition
        #
        # @return [VariableDefinition] variable definition container
        def from(value)
          case value
          when VariableDefinition then value
          when Symbol, String then from_symbol_or_string(value)
          when Hash then from_hash(value)
          when Array then from_array(value)
          else
            raise Error.new('Unsupported format of variable definition', class: value.class.name, value: value)
          end
        end

        private

        ##
        # Create variable definition container from Symbol or String
        #
        # @param type [Symbol, String] variable type
        #
        # @return [VariableDefinition] variable definition container
        def from_symbol_or_string(type)
          new(type)
        end

        ##
        # Create variable definition container from Hash
        #
        # @param hash [Hash] variable definition parameters
        # @option hash [String, Symbol] :type variable type
        # @option hash [Object, nil] :default default value
        # @option hash [Array<Directive, Hash, Array>] :directives list of directives
        #
        # @return [VariableDefinition] variable definition container
        def from_hash(hash)
          type = hash[:type]
          default = hash.fetch(:default, UNDEFINED)
          directives = hash.fetch(:directives, [])

          new(type, default, directives)
        end

        ##
        # Create variable definition container from Array
        #
        # @param array [Array] variable definition parameters
        # @option array [String, Symbol] 0 variable type
        # @option array [Object, nil] 1 default value
        # @option array [Array<Directive, Hash, Array>] 2 list of directives
        #
        # @return [VariableDefinition] variable definition container
        def from_array(array)
          type = array[0]
          default = array.fetch(1, UNDEFINED)
          directives = array.fetch(2, [])

          new(type, default, directives)
        end
      end
    end
  end
end

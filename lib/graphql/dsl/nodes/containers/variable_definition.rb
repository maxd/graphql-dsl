# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # Container for variable definition
    class VariableDefinition
      ##
      # @return [String, Symbol, nil] variable name
      attr_reader :name

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
      # @param name [String, Symbol] variable name
      # @param type [String, Symbol] variable type
      # @param default [Object, nil] default value
      # @param directives [Array<Directive, Hash, Array>] list of directives
      def initialize(name, type, default = UNDEFINED, directives = [])
        raise Error, 'Variable name must be specified' if name.nil? || name.empty?
        raise Error, 'Variable type must be specified' if type.nil? || type.empty?

        @name = name
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
        def from(name, value)
          case value
          when VariableDefinition then value
          when Symbol, String then from_symbol_or_string(name, value)
          when Hash then from_hash(name, value)
          when Array then from_array(name, value)
          else
            raise Error.new('Unsupported format of variable definition', class: value.class.name, value: value)
          end
        end

        private

        ##
        # Create variable definition container from Symbol or String
        #
        # @param name [String, Symbol] variable name
        # @param type [Symbol, String] variable type
        #
        # @return [VariableDefinition] variable definition container
        def from_symbol_or_string(name, type)
          new(name, type)
        end

        ##
        # Create variable definition container from Hash
        #
        # @param name [String, Symbol] variable name
        # @param hash [Hash] variable definition parameters
        # @option hash [String, Symbol] :type variable type
        # @option hash [Object, nil] :default default value
        # @option hash [Array<Directive, Hash, Array>] :directives list of directives
        #
        # @return [VariableDefinition] variable definition container
        def from_hash(name, hash)
          type = hash[:type]
          default = hash.fetch(:default, UNDEFINED)
          directives = hash.fetch(:directives, [])

          new(name, type, default, directives)
        end

        ##
        # Create variable definition container from Array
        #
        # @param name [String, Symbol] variable name
        # @param array [Array] variable definition parameters
        # @option array [String, Symbol] 0 variable type
        # @option array [Object, nil] 1 default value
        # @option array [Array<Directive, Hash, Array>] 2 list of directives
        #
        # @return [VariableDefinition] variable definition container
        def from_array(name, array)
          type = array[0]
          default = array.fetch(1, UNDEFINED)
          directives = array.fetch(2, [])

          new(name, type, default, directives)
        end
      end
    end
  end
end

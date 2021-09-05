# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # Container for directive
    class Directive
      ##
      # @return [String, Symbol, nil] directive name
      attr_reader :name

      ##
      # @return [Hash] arguments
      attr_reader :arguments

      ##
      # Create directive container
      #
      # @param name [String, Symbol] directive name
      # @param arguments [Hash] arguments
      def initialize(name, arguments = {})
        raise Error, 'Variable name must be specified' if name.nil? || name.empty?

        @name = name
        @arguments = arguments
      end

      class << self
        ##
        # Create directive container from Hash, Array or Directive
        #
        # @param value [Directive, Hash, Array] Hash, Array or Directive
        #
        # @return [Directive] directive container
        def from(value)
          case value
          when Directive then value
          when Hash then from_hash(value)
          when Array then from_array(value)
          else
            raise Error.new('Unsupported format of directive', class: value.class.name, value: value)
          end
        end

        private

        ##
        # Create directive container from Hash
        #
        # @param hash [Hash] directive parameters
        # @option hash [String, Symbol] :name directive name
        # @option hash [Hash] :args arguments
        #
        # @return [Directive] directive container
        def from_hash(hash)
          name = hash[:name]
          arguments = hash.fetch(:args, {})

          new(name, arguments)
        end

        ##
        # Create directive container from Array
        #
        # @param array [Array] directive parameters
        # @option array [String, Symbol] 0 directive name
        # @option array [Hash] 1 arguments
        #
        # @return [Directive] directive container
        def from_array(array)
          name = array[0]
          arguments = array.fetch(1, {})

          new(name, arguments)
        end
      end
    end
  end
end

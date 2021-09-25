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
        # Create directive container from argument value
        #
        # @param value [] argument value
        #
        # @return [Directive] directive container
        def from(value)
          case value
          when Directive then value
          when Symbol, String then new(value)
          else
            raise Error.new('Unsupported format of directive', class: value.class.name, value: value)
          end
        end
      end
    end
  end
end

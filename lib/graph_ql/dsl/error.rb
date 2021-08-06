# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # GraphQL DSL error
    class Error < StandardError
      ##
      # @return [Hash] additional error arguments
      attr_reader :arguments

      ##
      # Create GraphQL error
      #
      # @param msg [String] error message
      # @param arguments [Hash] additional error arguments
      def initialize(msg = nil, **arguments)
        super(msg)

        @arguments = arguments
      end
    end
  end
end

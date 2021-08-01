# frozen_string_literal: true

require_relative 'fields'

module GraphQL
  module DSL
    module Nodes
      ##
      # Field GraphQL node
      class Field < Node
        ##
        # @!parse [include] Fields
        include Fields

        ##
        # @return [Hash] list of filed arguments
        attr_reader :__arguments

        ##
        # Create field
        #
        # @param name [String, Symbol] field name
        # @param arguments [Hash] field arguments
        # @param block [Proc] declare DSL for sub-fields
        def initialize(name, arguments = {}, &block)
          unless arguments.is_a?(Hash)
            raise GraphQL::DSL::Error.new('GraphQL field accept named arguments only', {
              field_name: name,
              field_arguments: arguments,
            })
          end

          super(name, &block)

          @__arguments = arguments
        end

        ##
        # See {Node#to_gql}
        def to_gql(level = 0) # rubocop:disable Metrics/AbcSize
          field_name = __name.to_s
          field_arguments = __arguments.empty? ? '' : __arguments_to_s(__arguments, initial: true)

          result = []
          result << __indent(level) + field_name + field_arguments

          unless __nodes.empty?
            result << "#{__indent(level)}{"
            result += __nodes.map { |node| node.to_gql(level + 1) }
            result << "#{__indent(level)}}"
          end

          result.join("\n")
        end

        private

        ##
        # Convert field arguments to field signature of hash
        #
        # @param arguments [] field arguments
        # @param initial [Boolean] specify first call of this method or not
        #
        # @return [String] representation of arguments as string
        def __arguments_to_s(arguments, initial: false)
          case arguments
          when Hash
            __arguments_to_hash(arguments, initial)
          when Array
            __arguments_to_array(arguments)
          when String, Symbol
            __arguments_to_string(arguments)
          else
            arguments.to_s
          end
        end

        ##
        # Convert arguments to hash
        #
        # @param arguments [Hash] arguments
        # @param initial [Boolean] specify first call of this method or not
        #
        # @return [String] representation of arguments as string
        def __arguments_to_hash(arguments, initial)
          result = arguments.map do |name, value|
            "#{name}: #{__arguments_to_s(value)}"
          end.join(', ')

          initial ? "(#{result})" : "{#{result}}"
        end

        ##
        # Convert arguments to array
        #
        # @param arguments [Array] arguments
        #
        # @return [String] representation of arguments as string
        def __arguments_to_array(arguments)
          result = arguments.map do |argument|
            __arguments_to_s(argument)
          end.join(', ')

          "[#{result}]"
        end

        ##
        # Convert arguments to string
        #
        # @param arguments [String, Symbol] arguments
        #
        # @return [String] representation of arguments as string
        def __arguments_to_string(arguments)
          %("#{arguments}")
        end
      end
    end
  end
end

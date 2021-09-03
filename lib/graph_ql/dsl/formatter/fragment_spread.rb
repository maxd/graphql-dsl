# frozen_string_literal: true

module GraphQL
  module DSL
    class Formatter # rubocop:disable Style/Documentation
      private

      ##
      # Format fragment spread as string
      #
      # @param fragment_spread [GraphQL::DSL::Nodes::FragmentSpread] fragment spread node
      # @param level [Integer] indent level
      #
      # @return [String] representation of fragment spread as string
      def format_fragment_spread(fragment_spread, level)
        fragment_spread_signature = [
          fragment_spread.__name,
          format_directives(fragment_spread.__directives, false),
        ].compact.join(' ')

        indent(level) + "...#{fragment_spread_signature}"
      end
    end
  end
end

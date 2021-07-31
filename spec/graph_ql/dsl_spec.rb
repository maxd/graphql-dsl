# frozen_string_literal: true

RSpec.describe GraphQL::DSL do
  context 'query' do
    subject(:query) { described_class.query }

    it 'create query' do
      expect(query).to be_a(GraphQL::DSL::Nodes::Query)

      expect(query.to_gql).to eq(<<~GQL.strip)
        {
        }
      GQL
    end
  end
end

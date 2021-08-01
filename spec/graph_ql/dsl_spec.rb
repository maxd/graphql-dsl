# frozen_string_literal: true

RSpec.describe GraphQL::DSL do
  context 'executable_document' do
    subject(:query) do
      described_class.executable_document do
        query {
          field1
        }
      end
    end

    it 'create query' do
      expect(query).to be_a(GraphQL::DSL::Nodes::ExecutableDocument)

      expect(query.to_gql).to eq(<<~GQL.strip)
        {
          field1
        }
      GQL
    end
  end

  context 'query' do
    subject(:query) { described_class.query }

    it 'create query' do
      expect(query).to be_a(GraphQL::DSL::Nodes::Operation)
      expect(query.__operation_type).to eq(:query)

      expect(query.to_gql).to eq(<<~GQL.strip)
        {
        }
      GQL
    end
  end

  context 'fragment' do
    subject(:fragment) { described_class.fragment(:fragment1, :Type1) }

    it 'create query' do
      expect(fragment).to be_a(GraphQL::DSL::Nodes::FragmentOperation)

      expect(fragment.to_gql).to eq(<<~GQL.strip)
        fragment fragment1 on Type1
        {
        }
      GQL
    end
  end
end

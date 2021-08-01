# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::QueryOperation do
  context 'to_gql' do
    context 'without name' do
      subject(:query) { described_class.new }

      it 'valid result' do
        expect(query.to_gql).to eq(<<~GQL.strip)
          {
          }
        GQL
      end
    end

    context 'with name' do
      shared_examples 'build query' do |name|
        subject(:query) { described_class.new(name) }

        it 'valid result' do
          expect(query.to_gql).to eq(<<~GQL.strip)
            query #{name}
            {
            }
          GQL
        end
      end

      it_behaves_like 'build query', 'query1'
      it_behaves_like 'build query', :query1
    end

    context 'with fields' do
      subject(:query) do
        described_class.new {
          field1
          field2
        }
      end

      it 'valid result' do
        expect(query.to_gql).to eq(<<~GQL.strip)
          {
            field1
            field2
          }
        GQL
      end
    end
  end
end

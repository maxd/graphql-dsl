# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::InlineFragment do
  context 'initializer' do
    context 'without block' do
      subject(:inline_fragment) { described_class.new(:Type1) }

      it 'valid result' do
        expect { inline_fragment }.to raise_error GraphQL::DSL::Error,
          'Sub-fields must be specified for inline fragment'
      end
    end
  end

  context 'to_gql' do
    context 'with type' do
      shared_examples 'build query' do |type|
        subject(:inline_fragment) do
          described_class.new(type) {
            field1
            field2
          }
        end

        it 'valid result' do
          expect(inline_fragment.to_gql).to eq(<<~GQL.strip)
            ... on #{type}
            {
              field1
              field2
            }
          GQL
        end
      end

      it_behaves_like 'build query', 'Type1'
      it_behaves_like 'build query', :Type1
    end

    context 'without type' do
      subject(:inline_fragment) do
        described_class.new {
          field1
          field2
        }
      end

      it 'valid result' do
        expect(inline_fragment.to_gql).to eq(<<~GQL.strip)
          ...
          {
            field1
            field2
          }
        GQL
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::FragmentSpread do
  context 'to_gql' do
    context 'with name' do
      shared_examples 'build query' do |name|
        subject(:fragment) { described_class.new(name) }

        it 'valid result' do
          expect(fragment.to_gql).to eq(<<~GQL.strip)
            ...#{name}
          GQL
        end
      end

      it_behaves_like 'build query', 'fragment1'
      it_behaves_like 'build query', :fragment1
    end

    context 'with directives' do
      subject(:fragment) { described_class.new(:fragment1, [[:directive1, { a: 1 }]]) }

      it 'valid result' do
        expect(fragment.to_gql).to eq(<<~GQL.strip)
          ...fragment1 @directive1(a: 1)
        GQL
      end
    end
  end
end

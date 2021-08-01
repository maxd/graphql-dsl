# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::InlineFragment do
  context 'to_gql' do
    context 'with name only (fragment)' do
      shared_examples 'build query' do |name|
        subject(:fragment) { described_class.new(name) }

        it 'valid result' do
          expect(fragment.to_gql).to eq(<<~GQL.strip)
            ... #{name}
          GQL
        end
      end

      it_behaves_like 'build query', 'fragment1'
      it_behaves_like 'build query', :fragment1
    end

    context 'with type only (inline fragment)' do
      shared_examples 'build query' do |type|
        subject(:fragment) do
          described_class.new(nil, type) {
            field1
            field2
          }
        end

        it 'valid result' do
          expect(fragment.to_gql).to eq(<<~GQL.strip)
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

    context 'with name and type' do
      subject(:fragment) { described_class.new(:field1, :Type1) }

      it 'valid result' do
        expect { fragment }.to raise_error GraphQL::DSL::Error,
          'Only one from `name` or `type` arguments must be specified'
      end
    end

    context 'with name and block' do
      subject(:fragment) do
        described_class.new(:field1) {
          field1
        }
      end

      it 'valid result' do
        expect { fragment }.to raise_error GraphQL::DSL::Error,
          'Sub-fields must not be specified for fragment'
      end
    end

    context 'with type and without block' do
      subject(:fragment) do
        described_class.new(nil, :Type1)
      end

      it 'valid result' do
        expect { fragment }.to raise_error GraphQL::DSL::Error,
          'Sub-fields must be specified for inline fragment'
      end
    end
  end
end

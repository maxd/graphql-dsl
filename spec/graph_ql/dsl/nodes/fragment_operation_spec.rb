# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::FragmentOperation do
  context 'initializer' do
    context 'without name' do
      shared_examples 'validate name argument' do |name|
        subject(:fragment) { described_class.new(name, :Type1) }

        it 'valid result' do
          expect { fragment }.to raise_error GraphQL::DSL::Error, '`name` must be specified'
        end
      end

      it_behaves_like 'validate name argument', nil
      it_behaves_like 'validate name argument', ''
    end

    context 'without type' do
      shared_examples 'validate type argument' do |type|
        subject(:fragment) { described_class.new(:field1, type) }

        it 'valid result' do
          expect { fragment }.to raise_error GraphQL::DSL::Error, '`type` must be specified'
        end
      end

      it_behaves_like 'validate type argument', nil
      it_behaves_like 'validate type argument', ''
    end
  end

  context 'to_gql' do
    context 'with name' do
      shared_examples 'build query' do |name|
        subject(:fragment) { described_class.new(name, :Type1) }

        it 'valid result' do
          expect(fragment.to_gql).to eq(<<~GQL.strip)
            fragment #{name} on Type1
            {
            }
          GQL
        end
      end

      it_behaves_like 'build query', 'fragment1'
      it_behaves_like 'build query', :fragment1
    end

    context 'with type' do
      shared_examples 'build query' do |type|
        subject(:fragment) { described_class.new(:fragment1, type) }

        it 'valid result' do
          expect(fragment.to_gql).to eq(<<~GQL.strip)
            fragment fragment1 on #{type}
            {
            }
          GQL
        end
      end

      it_behaves_like 'build query', 'Type1'
      it_behaves_like 'build query', :Type1
    end

    context 'with fields' do
      subject(:fragment) do
        described_class.new(:fragment1, :Type1) {
          field1
          field2
        }
      end

      it 'valid result' do
        expect(fragment.to_gql).to eq(<<~GQL.strip)
          fragment fragment1 on Type1
          {
            field1
            field2
          }
        GQL
      end
    end

    context 'with directives' do
      subject(:fragment) do
        described_class.new(:fragment1, :Type1, [[:directive1, { a: 1 }]]) {
          field1
          field2
        }
      end

      it 'valid result' do
        expect(fragment.to_gql).to eq(<<~GQL.strip)
          fragment fragment1 on Type1 @directive1(a: 1)
          {
            field1
            field2
          }
        GQL
      end
    end

    context 'with fragment' do
      subject(:fragment) do
        described_class.new(:fragment1, :Type1) {
          __fragment :fragment1
        }
      end

      it 'valid result' do
        expect(fragment.to_gql).to eq(<<~GQL.strip)
          fragment fragment1 on Type1
          {
            ...fragment1
          }
        GQL
      end
    end

    context 'with inline fragment' do
      subject(:fragment) do
        described_class.new(:fragment1, :Type1) {
          __inline_fragment(:Type1) {
            field1
          }
        }
      end

      it 'valid result' do
        expect(fragment.to_gql).to eq(<<~GQL.strip)
          fragment fragment1 on Type1
          {
            ... on Type1
            {
              field1
            }
          }
        GQL
      end
    end
  end
end

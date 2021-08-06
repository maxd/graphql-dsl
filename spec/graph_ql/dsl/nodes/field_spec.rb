# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::Field do
  context 'to_gql' do
    context 'with name' do
      shared_examples 'build query' do |name|
        subject(:field) { described_class.new(name) }

        it 'valid result' do
          expect(field.to_gql).to eq(name.to_s)
        end
      end

      it_behaves_like 'build query', 'field1'
      it_behaves_like 'build query', :field1
    end

    context 'with alias of name' do
      shared_examples 'build query' do |name, name_alias|
        subject(:field) { described_class.new(name, __alias: name_alias) }

        it 'valid result' do
          expect(field.to_gql).to eq("#{name_alias}: #{name}")
        end
      end

      it_behaves_like 'build query', :field1, 'alias1'
      it_behaves_like 'build query', :field1, :alias1
    end

    context 'with name and arguments' do
      context 'reject ordered arguments' do
        subject(:field) { described_class.new('field1', 1) }

        it 'raise error' do
          expect { field }.to raise_error GraphQL::DSL::Error, 'GraphQL field accept named arguments only'
        end
      end

      shared_examples 'with value' do |value, expected_arguments|
        subject(:field) { described_class.new('field1', { value: value }) }

        it "valid result with #{value.class.name}" do
          expect(field.to_gql).to eq("field1(value: #{expected_arguments})")
        end
      end

      it_behaves_like 'with value', nil, 'null'
      it_behaves_like 'with value', 1, '1'
      it_behaves_like 'with value', 1.0, '1.0'
      it_behaves_like 'with value', 'string', '"string"'
      it_behaves_like 'with value', :symbol, 'symbol'
      it_behaves_like 'with value', { a: 1, b: { c: 2 } }, '{a: 1, b: {c: 2}}'
      it_behaves_like 'with value', [1, '2', 3.0], '[1, "2", 3.0]'
    end

    context 'with sub-fields' do
      subject(:field) do
        described_class.new('field1') {
          subfield1
          subfield2
        }
      end

      it 'valid result' do
        expect(field.to_gql).to eq(<<~GQL.strip)
          field1
          {
            subfield1
            subfield2
          }
        GQL
      end
    end

    context 'with sub-fields and arguments' do
      subject(:field) do
        described_class.new('field1', { id: 1 }) {
          subfield1 id: 1
          subfield2 id: 2
        }
      end

      it 'valid result' do
        expect(field.to_gql).to eq(<<~GQL.strip)
          field1(id: 1)
          {
            subfield1(id: 1)
            subfield2(id: 2)
          }
        GQL
      end
    end

    context 'with fragment' do
      subject(:field) do
        described_class.new('field1') {
          __fragment :fragment1
        }
      end

      it 'valid result' do
        expect(field.to_gql).to eq(<<~GQL.strip)
          field1
          {
            ...fragment1
          }
        GQL
      end
    end

    context 'with inline fragment' do
      subject(:field) do
        described_class.new('field1') {
          __inline_fragment(:Type1) {
            subfield1
            subfield2
          }
        }
      end

      it 'valid result' do
        expect(field.to_gql).to eq(<<~GQL.strip)
          field1
          {
            ... on Type1
            {
              subfield1
              subfield2
            }
          }
        GQL
      end
    end
  end
end

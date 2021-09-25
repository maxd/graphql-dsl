# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_field' do
    def field(field_name, field_alias = nil, arguments = {}, directives = [], &block)
      GraphQL::DSL::Field.new(field_name, field_alias, arguments, directives, &block)
    end

    def format_field(field, level = 0)
      formatter.send(:format_field, field, level)
    end

    context 'with name' do
      shared_examples 'format' do |name|
        subject(:result) { format_field(field(name)) }

        it 'valid result' do
          expect(result).to eq(name.to_s)
        end
      end

      it_behaves_like 'format', 'field1'
      it_behaves_like 'format', :field1
    end

    context 'with alias' do
      shared_examples 'format' do |name, name_alias|
        subject(:result) { format_field(field(name, name_alias)) }

        it 'valid result' do
          expect(result).to eq("#{name_alias}: #{name}")
        end
      end

      it_behaves_like 'format', :field1, 'alias1'
      it_behaves_like 'format', :field1, :alias1
    end

    context 'with arguments' do
      subject(:result) { format_field(field('field1', nil, { a: 1, b: 2 })) }

      it 'valid result' do
        expect(result).to eq('field1(a: 1, b: 2)')
      end
    end

    context 'with directives', :factories do
      subject(:result) do
        format_field(field('field1', nil, {}, [
          directive(:directive1, a: 1),
          directive(:directive2, b: 2),
        ]))
      end

      it do
        expect(result).to eq('field1 @directive1(a: 1) @directive2(b: 2)')
      end
    end

    context 'with selection set' do
      subject(:result) do
        format_field(field('field1') {
          subfield1

          __fragment :fragment1

          __inline_fragment(:Type1) {
            subfield2
          }
        })
      end

      it 'valid result' do
        expect(result).to eq(<<~GQL.strip)
          field1
          {
            subfield1
            ...fragment1
            ... on Type1
            {
              subfield2
            }
          }
        GQL
      end
    end
  end
end

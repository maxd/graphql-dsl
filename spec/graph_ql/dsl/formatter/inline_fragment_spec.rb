# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_inline_fragment' do
    def inline_fragment(type = nil, directives = [], &block)
      GraphQL::DSL::Nodes::InlineFragment.new(type, directives, &block)
    end

    def format_inline_fragment(inline_fragment, level = 0)
      formatter.send(:format_inline_fragment, inline_fragment, level)
    end

    context 'with type' do
      shared_examples 'result' do |type|
        subject(:result) do
          format_inline_fragment(inline_fragment(type) {
            field1
          })
        end

        it 'valid result' do
          expect(result).to eq(<<~GQL.strip)
            ... on #{type}
            {
              field1
            }
          GQL
        end
      end

      it_behaves_like 'result', 'Type1'
      it_behaves_like 'result', :Type1
    end

    context 'without type' do
      subject(:result) do
        format_inline_fragment(inline_fragment {
          field1
        })
      end

      it 'valid result' do
        expect(result).to eq(<<~GQL.strip)
          ...
          {
            field1
          }
        GQL
      end
    end

    context 'with directives' do
      subject(:result) do
        format_inline_fragment(inline_fragment(:Type1, [[:directive1, { a: 1 }]]) {
          field1
        })
      end

      it 'valid result' do
        expect(result).to eq(<<~GQL.strip)
          ... on Type1 @directive1(a: 1)
          {
            field1
          }
        GQL
      end
    end

    context 'with selection set' do
      subject(:result) do
        format_inline_fragment(inline_fragment(:Type1) {
          field1

          __fragment :fragment1

          __inline_fragment(:Type2) {
            field2
          }
        })
      end

      it 'valid result' do
        expect(result).to eq(<<~GQL.strip)
          ... on Type1
          {
            field1
            ...fragment1
            ... on Type2
            {
              field2
            }
          }
        GQL
      end
    end
  end
end

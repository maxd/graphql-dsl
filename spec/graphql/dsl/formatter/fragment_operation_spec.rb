# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_fragment_operation' do
    def fragment_operator(name, type, directives = [], &block)
      GraphQL::DSL::FragmentOperation.new(name, type, directives, &block)
    end

    def format_fragment_operation(fragment_operator, level = 0)
      formatter.send(:format_fragment_operation, fragment_operator, level)
    end

    context 'with name' do
      shared_examples 'result' do |name|
        subject(:result) { format_fragment_operation(fragment_operator(name, :Type1)) }

        it 'valid result' do
          expect(result).to eq(<<~GQL.strip)
            fragment #{name} on Type1
            {
            }
          GQL
        end
      end

      it_behaves_like 'result', 'fragment1'
      it_behaves_like 'result', :fragment1
    end

    context 'with type' do
      shared_examples 'result' do |type|
        subject(:result) { format_fragment_operation(fragment_operator(:fragment1, type)) }

        it 'valid result' do
          expect(result).to eq(<<~GQL.strip)
            fragment fragment1 on #{type}
            {
            }
          GQL
        end
      end

      it_behaves_like 'result', 'Type1'
      it_behaves_like 'result', :Type1
    end

    context 'with directives' do
      subject(:result) do
        format_fragment_operation(fragment_operator(:fragment1, :Type1, [[:directive1, { a: 1 }]]))
      end

      it 'valid result' do
        expect(result).to eq(<<~GQL.strip)
          fragment fragment1 on Type1 @directive1(a: 1)
          {
          }
        GQL
      end
    end

    context 'with selection set' do
      subject(:result) do
        format_fragment_operation(fragment_operator(:fragment1, :Type1) {
          field1

          __fragment :fragment1

          __inline_fragment(:Type2) {
            field2
          }
        })
      end

      it 'valid result' do
        expect(result).to eq(<<~GQL.strip)
          fragment fragment1 on Type1
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

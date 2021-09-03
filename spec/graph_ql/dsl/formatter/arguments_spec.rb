# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_arguments' do
    def format_arguments(value, is_const: false)
      formatter.send(:format_arguments, value, is_const)
    end

    context 'without arguments' do
      it { expect(format_arguments({})).to be_nil }
    end

    context 'with arguments' do
      it { expect(format_arguments({ a: 1 })).to eq('(a: 1)') }
      it { expect(format_arguments({ a: 1, b: 2 })).to eq('(a: 1, b: 2)') }
    end

    context 'with restricted variables' do
      it { expect(format_arguments({ a: :$a })).to eq('(a: $a)') }

      it do
        expect { format_arguments({ a: :$a }, is_const: true) }.to raise_error GraphQL::DSL::Error,
          'Value must be constant'
      end
    end
  end
end

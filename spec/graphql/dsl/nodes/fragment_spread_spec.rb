# frozen_string_literal: true

RSpec.describe GraphQL::DSL::FragmentSpread, :factories do
  let(:directives) { [directive(:directive1, a: 1)] }

  context '#initialize' do
    context 'with all arguments' do
      subject(:fragment_spread) do
        described_class.new(:field1, directives)
      end

      it('expected name') { expect(fragment_spread.__name).to eq(:field1) }
      it('expected directives') do
        expect(fragment_spread.__directives).to eq(directives)
      end
    end
  end
end

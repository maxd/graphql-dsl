# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::Mixins::Arguments do
  context '__arguments_to_s' do
    let(:test_class) do
      Class.new do
        include GraphQL::DSL::Nodes::Mixins::Arguments
      end
    end

    let(:object) { test_class.new }

    def __arguments_to_s(value)
      object.send(:__arguments_to_s, value)
    end

    context 'without arguments' do
      it { expect(__arguments_to_s({})).to eq('') }
    end

    context 'with arguments' do
      it { expect(__arguments_to_s({ a: 1 })).to eq('(a: 1)') }
      it { expect(__arguments_to_s({ a: 1, b: 2 })).to eq('(a: 1, b: 2)') }
    end
  end
end

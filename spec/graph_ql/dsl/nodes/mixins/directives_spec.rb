# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::Mixins::Directives do
  let(:test_class) do
    Class.new do
      include GraphQL::DSL::Nodes::Mixins::Directives
    end
  end

  let(:object) { test_class.new }

  context '#__directives_to_s' do
    def __directives_to_s(directives, is_const: false)
      object.send(:__directives_to_s, directives, is_const)
    end

    context 'without directives' do
      it { expect(__directives_to_s([])).to be_nil }
    end

    context 'with directives' do
      context 'as hash' do
        it { expect(__directives_to_s([{ name: :directive1 }])).to eq('@directive1') }
        it { expect(__directives_to_s([{ name: 'directive1' }])).to eq('@directive1') }

        it { expect(__directives_to_s([{ name: :directive1, args: {} }])).to eq('@directive1') }
        it { expect(__directives_to_s([{ name: :directive1, args: { a: 1 } }])).to eq('@directive1(a: 1)') }
      end

      context 'as array' do
        it { expect(__directives_to_s([[:directive1]])).to eq('@directive1') }
        it { expect(__directives_to_s([['directive1']])).to eq('@directive1') }

        it { expect(__directives_to_s([[:directive1, { a: 1 }]])).to eq('@directive1(a: 1)') }
      end
    end

    context '#__directive_name_to_s' do
      def __directive_name_to_s(name)
        object.send(:__directive_name_to_s, name)
      end

      it { expect(__directive_name_to_s(:directive1)).to eq('@directive1') }
      it { expect(__directive_name_to_s('directive1')).to eq('@directive1') }

      it { expect(__directive_name_to_s(:@directive1)).to eq('@directive1') }
      it { expect(__directive_name_to_s('@directive1')).to eq('@directive1') }
    end
  end
end

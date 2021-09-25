# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_directives', :factories do
    def format_directives(directives, is_const: false)
      directives = directives.map { |directive| GraphQL::DSL::Directive.from(directive) }
      formatter.send(:format_directives, directives, is_const)
    end

    context 'without directives' do
      it { expect(format_directives([])).to be_nil }
    end

    context 'with directives' do
      it { expect(format_directives([directive(:directive1)])).to eq('@directive1') }
      it { expect(format_directives([directive('directive1')])).to eq('@directive1') }

      it { expect(format_directives([directive(:directive1, a: 1)])).to eq('@directive1(a: 1)') }
    end
  end

  context '#format_directive_name' do
    def format_directive_name(name)
      formatter.send(:format_directive_name, name)
    end

    it { expect(format_directive_name(:directive1)).to eq('@directive1') }
    it { expect(format_directive_name('directive1')).to eq('@directive1') }

    it { expect(format_directive_name(:@directive1)).to eq('@directive1') }
    it { expect(format_directive_name('@directive1')).to eq('@directive1') }
  end
end

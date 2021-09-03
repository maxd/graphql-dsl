# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_value' do
    def format_value(value, is_const: false)
      formatter.send(:format_value, value, is_const)
    end

    context 'integer value' do
      it { expect(format_value(42)).to eq('42') }
      it { expect(format_value(0)).to eq('0') }
      it { expect(format_value(-42)).to eq('-42') }
    end

    context 'float value' do
      it { expect(format_value(42.42)).to eq('42.42') }
      it { expect(format_value(0.0)).to eq('0.0') }
      it { expect(format_value(-42.42)).to eq('-42.42') }
    end

    context 'string value' do
      it { expect(format_value('')).to eq('""') }
      it { expect(format_value('string')).to eq('"string"') }

      it { expect(format_value('"')).to eq('"\""') }
      it { expect(format_value("'")).to eq('"\'"') }

      it { expect(format_value('/')).to eq('"/"') }

      it { expect(format_value("\u2014")).to eq('"\u2014"') }

      it { expect(format_value('"')).to eq('"\\""') }
      it { expect(format_value('\\')).to eq('"\\\\"') }
      it { expect(format_value("\b")).to eq('"\b"') }
      it { expect(format_value("\f")).to eq('"\f"') }
      it { expect(format_value("\n")).to eq('"\n"') }
      it { expect(format_value("\r")).to eq('"\r"') }
      it { expect(format_value("\t")).to eq('"\t"') }
    end

    context 'boolean value' do
      it { expect(format_value(true)).to eq('true') }
      it { expect(format_value(false)).to eq('false') }
    end

    context 'null value' do
      it { expect(format_value(nil)).to eq('null') }
    end

    context 'variable value' do
      it { expect(format_value(:$variable)).to eq('$variable') }
      it do
        expect { format_value(:$variable, is_const: true) }.to raise_error GraphQL::DSL::Error,
          'Value must be constant'
      end
    end

    context 'enum value' do
      it { expect(format_value(:Type1)).to eq('Type1') }
    end

    context 'list value' do
      it { expect(format_value([])).to eq('[]') }
      it { expect(format_value([1])).to eq('[1]') }
      it { expect(format_value([1, 2])).to eq('[1, 2]') }

      it { expect(format_value([1.1])).to eq('[1.1]') }
      it { expect(format_value(['string'])).to eq('["string"]') }
      it { expect(format_value([true])).to eq('[true]') }
      it { expect(format_value([false])).to eq('[false]') }
      it { expect(format_value([nil])).to eq('[null]') }
      it { expect(format_value([:Type1])).to eq('[Type1]') }
      it { expect(format_value([[1]])).to eq('[[1]]') }
      it { expect(format_value([{ a: 1 }])).to eq('[{a: 1}]') }
    end

    context 'object value' do
      it { expect(format_value({})).to eq('{}') }
      it { expect(format_value({ a: 1 })).to eq('{a: 1}') }
      it { expect(format_value({ a: 1, b: 2 })).to eq('{a: 1, b: 2}') }

      it { expect(format_value({ a: 1.1 })).to eq('{a: 1.1}') }
      it { expect(format_value({ a: 'string' })).to eq('{a: "string"}') }
      it { expect(format_value({ a: true })).to eq('{a: true}') }
      it { expect(format_value({ a: false })).to eq('{a: false}') }
      it { expect(format_value({ a: nil })).to eq('{a: null}') }
      it { expect(format_value({ a: :Type1 })).to eq('{a: Type1}') }
      it { expect(format_value({ a: [1] })).to eq('{a: [1]}') }
      it { expect(format_value({ a: { b: 2 } })).to eq('{a: {b: 2}}') }
    end

    context 'unknown value' do
      it { expect { format_value(Object.new) }.to raise_error GraphQL::DSL::Error, 'Unsupported value type' }
    end
  end
end

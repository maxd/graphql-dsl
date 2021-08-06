# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::Mixins::Values do
  let(:test_class) do
    Class.new do
      include GraphQL::DSL::Nodes::Mixins::Values
    end
  end

  let(:object) { test_class.new }

  def __value_to_s(value)
    object.send(:__value_to_s, value)
  end

  context 'integer value' do
    it { expect(__value_to_s(42)).to eq('42') }
    it { expect(__value_to_s(0)).to eq('0') }
    it { expect(__value_to_s(-42)).to eq('-42') }
  end

  context 'float value' do
    it { expect(__value_to_s(42.42)).to eq('42.42') }
    it { expect(__value_to_s(0.0)).to eq('0.0') }
    it { expect(__value_to_s(-42.42)).to eq('-42.42') }
  end

  context 'string value' do
    it { expect(__value_to_s('')).to eq('""') }
    it { expect(__value_to_s('string')).to eq('"string"') }

    it { expect(__value_to_s('"')).to eq('"\""') }
    it { expect(__value_to_s("'")).to eq('"\'"') }

    it { expect(__value_to_s('/')).to eq('"/"') }

    it { expect(__value_to_s("\u2014")).to eq('"\u2014"') }

    it { expect(__value_to_s('"')).to eq('"\\""') }
    it { expect(__value_to_s('\\')).to eq('"\\\\"') }
    it { expect(__value_to_s("\b")).to eq('"\b"') }
    it { expect(__value_to_s("\f")).to eq('"\f"') }
    it { expect(__value_to_s("\n")).to eq('"\n"') }
    it { expect(__value_to_s("\r")).to eq('"\r"') }
    it { expect(__value_to_s("\t")).to eq('"\t"') }
  end

  context 'boolean value' do
    it { expect(__value_to_s(true)).to eq('true') }
    it { expect(__value_to_s(false)).to eq('false') }
  end

  context 'null value' do
    it { expect(__value_to_s(nil)).to eq('null') }
  end

  context 'enum value' do
    it { expect(__value_to_s(:Type1)).to eq('Type1') }
  end

  context 'list value' do
    it { expect(__value_to_s([])).to eq('[]') }
    it { expect(__value_to_s([1])).to eq('[1]') }
    it { expect(__value_to_s([1, 2])).to eq('[1, 2]') }

    it { expect(__value_to_s([1.1])).to eq('[1.1]') }
    it { expect(__value_to_s(['string'])).to eq('["string"]') }
    it { expect(__value_to_s([true])).to eq('[true]') }
    it { expect(__value_to_s([false])).to eq('[false]') }
    it { expect(__value_to_s([nil])).to eq('[null]') }
    it { expect(__value_to_s([:Type1])).to eq('[Type1]') }
    it { expect(__value_to_s([[1]])).to eq('[[1]]') }
    it { expect(__value_to_s([{ a: 1 }])).to eq('[{a: 1}]') }
  end

  context 'object value' do
    it { expect(__value_to_s({})).to eq('{}') }
    it { expect(__value_to_s({ a: 1 })).to eq('{a: 1}') }
    it { expect(__value_to_s({ a: 1, b: 2 })).to eq('{a: 1, b: 2}') }

    it { expect(__value_to_s({ a: 1.1 })).to eq('{a: 1.1}') }
    it { expect(__value_to_s({ a: 'string' })).to eq('{a: "string"}') }
    it { expect(__value_to_s({ a: true })).to eq('{a: true}') }
    it { expect(__value_to_s({ a: false })).to eq('{a: false}') }
    it { expect(__value_to_s({ a: nil })).to eq('{a: null}') }
    it { expect(__value_to_s({ a: :Type1 })).to eq('{a: Type1}') }
    it { expect(__value_to_s({ a: [1] })).to eq('{a: [1]}') }
    it { expect(__value_to_s({ a: { b: 2 } })).to eq('{a: {b: 2}}') }
  end

  context 'unknown value' do
    it { expect { __value_to_s(Object.new) }.to raise_error GraphQL::DSL::Error, 'Unsupported value type' }
  end
end

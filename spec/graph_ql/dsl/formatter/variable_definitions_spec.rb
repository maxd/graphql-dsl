# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_variable_definitions' do
    def format_variable_definitions(value)
      formatter.send(:format_variable_definitions, value)
    end

    context 'without variable definitions' do
      it { expect(format_variable_definitions({})).to be_nil }
    end

    context 'with variable definitions' do
      it { expect(format_variable_definitions({ a: :String })).to eq('($a: String)') }
      it { expect(format_variable_definitions({ a: :String, b: :Int })).to eq('($a: String, $b: Int)') }
    end
  end

  context '#format_variable_definition' do
    def format_variable_definition(value)
      formatter.send(:format_variable_definition, value)
    end

    context 'variable definition as symbol' do
      it 'validate type definition' do
        expect { format_variable_definition(:'') }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
      end

      it { expect(format_variable_definition(:String)).to eq('String') }
    end

    context 'variable definition as string' do
      it 'validate type definition' do
        expect { format_variable_definition('') }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
      end

      it { expect(format_variable_definition('String')).to eq('String') }
    end

    context 'variable definition as hash' do
      it 'validate type definition', :aggregate_failures do
        expect { format_variable_definition({}) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { format_variable_definition({ type: nil }) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { format_variable_definition({ type: :'' }) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { format_variable_definition({ type: '' }) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
      end

      it { expect(format_variable_definition({ type: :String })).to eq('String') }
      it { expect(format_variable_definition({ type: 'String' })).to eq('String') }

      it { expect(format_variable_definition({ type: :String, default: 'Value' })).to eq('String = "Value"') }
      it { expect(format_variable_definition({ type: 'String', default: 'Value' })).to eq('String = "Value"') }

      it do
        expect(format_variable_definition({
          type: :String,
          default: 'Value',
          directives: [[:directive1, { a: 1 }], [:directive2, { b: 2 }]],
        })).to eq('String = "Value" @directive1(a: 1) @directive2(b: 2)')
      end

      it 'variables restricted in default values' do
        expect { format_variable_definition({ type: :String, default: :$variable }) }
          .to raise_error GraphQL::DSL::Error, 'Value must be constant'
      end
    end

    context 'variable definition as array' do
      it 'validate type definition', :aggregate_failures do
        expect { format_variable_definition([]) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { format_variable_definition([nil]) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { format_variable_definition([:'']) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { format_variable_definition(['']) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
      end

      it { expect(format_variable_definition([:String])).to eq('String') }
      it { expect(format_variable_definition(['String'])).to eq('String') }

      it { expect(format_variable_definition([:String, nil])).to eq('String = null') }
      it { expect(format_variable_definition(['String', nil])).to eq('String = null') }

      it { expect(format_variable_definition([:String, 'Value'])).to eq('String = "Value"') }
      it { expect(format_variable_definition(%w[String Value])).to eq('String = "Value"') }

      it do
        expect(format_variable_definition([
          :String,
          'Value',
          [[:directive1, { a: 1 }], [:directive2, { b: 2 }]],
        ])).to eq('String = "Value" @directive1(a: 1) @directive2(b: 2)')
      end

      it 'variables restricted in default values' do
        expect { format_variable_definition(%i[String $variable]) }
          .to raise_error GraphQL::DSL::Error, 'Value must be constant'
      end
    end
  end
end

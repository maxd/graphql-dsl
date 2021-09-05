# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_variable_definitions' do
    def format_variable_definitions(variable_definitions)
      variable_definitions = variable_definitions.map do |variable_name, variable_definition|
        GraphQL::DSL::VariableDefinition.from(variable_name, variable_definition)
      end
      formatter.send(:format_variable_definitions, variable_definitions)
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
    def format_variable_definition(variable_definition)
      variable_name, variable_signature = variable_definition.first
      variable_definition = GraphQL::DSL::VariableDefinition.from(variable_name, variable_signature)

      formatter.send(:format_variable_definition, variable_definition)
    end

    it 'validate type definition', :aggregate_failures do
      expect { format_variable_definition(a: {}) }.to raise_error GraphQL::DSL::Error,
        /Variable type must be specified/
      expect { format_variable_definition(a: { type: nil }) }.to raise_error GraphQL::DSL::Error,
        /Variable type must be specified/
      expect { format_variable_definition(a: { type: :'' }) }.to raise_error GraphQL::DSL::Error,
        /Variable type must be specified/
      expect { format_variable_definition(a: { type: '' }) }.to raise_error GraphQL::DSL::Error,
        /Variable type must be specified/
    end

    it { expect(format_variable_definition(a: { type: :String })).to eq('$a: String') }
    it { expect(format_variable_definition(a: { type: 'String' })).to eq('$a: String') }

    it { expect(format_variable_definition(a: { type: :String, default: 'Value' })).to eq('$a: String = "Value"') }
    it { expect(format_variable_definition(a: { type: 'String', default: 'Value' })).to eq('$a: String = "Value"') }

    it do
      expect(format_variable_definition(a: {
        type: :String,
        default: 'Value',
        directives: [[:directive1, { a: 1 }], [:directive2, { b: 2 }]],
      })).to eq('$a: String = "Value" @directive1(a: 1) @directive2(b: 2)')
    end

    it 'variables restricted in default values' do
      expect { format_variable_definition(a: { type: :String, default: :$variable }) }
        .to raise_error GraphQL::DSL::Error, /Value must be constant/
    end
  end
end

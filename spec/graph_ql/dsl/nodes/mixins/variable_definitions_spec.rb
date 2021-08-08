# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::Mixins::VariableDefinitions do
  let(:test_class) do
    Class.new do
      include GraphQL::DSL::Nodes::Mixins::VariableDefinitions
    end
  end

  let(:object) { test_class.new }

  context '#__variable_definitions_to_s' do
    def __variable_definitions_to_s(value)
      object.send(:__variable_definitions_to_s, value)
    end

    context 'without variable definitions' do
      it { expect(__variable_definitions_to_s({})).to be_nil }
    end

    context 'with variable definitions' do
      it { expect(__variable_definitions_to_s({ a: :String })).to eq('($a: String)') }
      it { expect(__variable_definitions_to_s({ a: :String, b: :Int })).to eq('($a: String, $b: Int)') }
    end
  end

  context '#__variable_definition_to_s' do
    def __variable_definition_to_s(value)
      object.send(:__variable_definition_to_s, value)
    end

    context 'variable definition as symbol' do
      it 'validate type definition' do
        expect { __variable_definition_to_s(:'') }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
      end

      it { expect(__variable_definition_to_s(:String)).to eq('String') }
    end

    context 'variable definition as string' do
      it 'validate type definition' do
        expect { __variable_definition_to_s('') }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
      end

      it { expect(__variable_definition_to_s('String')).to eq('String') }
    end

    context 'variable definition as hash' do
      it 'validate type definition', :aggregate_failures do
        expect { __variable_definition_to_s({}) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { __variable_definition_to_s({ type: nil }) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { __variable_definition_to_s({ type: :'' }) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { __variable_definition_to_s({ type: '' }) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
      end

      it { expect(__variable_definition_to_s({ type: :String })).to eq('String') }
      it { expect(__variable_definition_to_s({ type: 'String' })).to eq('String') }

      it { expect(__variable_definition_to_s({ type: :String, default: 'Value' })).to eq('String = "Value"') }
      it { expect(__variable_definition_to_s({ type: 'String', default: 'Value' })).to eq('String = "Value"') }

      it 'variables restricted in default values' do
        expect { __variable_definition_to_s({ type: 'String', default: :$variable }) }
          .to raise_error GraphQL::DSL::Error, 'Value must be constant'
      end
    end

    context 'variable definition as array' do
      it 'validate type definition', :aggregate_failures do
        expect { __variable_definition_to_s([]) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { __variable_definition_to_s([nil]) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { __variable_definition_to_s([:'']) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
        expect { __variable_definition_to_s(['']) }.to raise_error GraphQL::DSL::Error,
          'Variable type must be specified'
      end

      it { expect(__variable_definition_to_s([:String])).to eq('String') }
      it { expect(__variable_definition_to_s(['String'])).to eq('String') }

      it { expect(__variable_definition_to_s([:String, nil])).to eq('String = null') }
      it { expect(__variable_definition_to_s(['String', nil])).to eq('String = null') }

      it { expect(__variable_definition_to_s([:String, 'Value'])).to eq('String = "Value"') }
      it { expect(__variable_definition_to_s(%w[String Value])).to eq('String = "Value"') }

      it 'variables restricted in default values' do
        expect { __variable_definition_to_s(%i[String $variable]) }
          .to raise_error GraphQL::DSL::Error, 'Value must be constant'
      end
    end
  end
end

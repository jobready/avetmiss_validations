require 'spec_helper'

describe AvetmissValidations::ActiveModel::Errors do
  let(:errors) { described_class.new(base, validator) }
  let(:base) { double(:model_proxy) }
  let(:validator) { double(:validator) }
  let(:message) { 'its a message' }
  let(:options) { { validator_type: :method_name } }

  describe '#add' do
    subject { errors.add(attribute, message, options) }

    describe 'when attribute is' do
      context ':base' do
        let(:attribute) { :base }

        it 'adds a result with an empty message' do
          expect(validator).to receive(:add_result)
            .with({
              base: base,
              attribute: :base,
              value: '',
              message: message,
              validator_type: :method_name
            })

          subject
        end
      end

      context 'not :base' do
        let(:attribute) { :foo }

        it 'adds a result' do
          expect(base).to receive(:foo) { 'foo_result' }

          expect(validator).to receive(:add_result)
            .with({
              base: base,
              attribute: :foo,
              value: 'foo_result',
              message: message,
              validator_type: :method_name
            })

          subject
        end
      end
    end
  end
end

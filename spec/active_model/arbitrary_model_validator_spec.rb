require 'spec_helper'

describe AvetmissValidations::ActiveModel::ArbitraryModelValidator do
  let(:validator) { described_class.new(validator_options) }
  let(:store_proxy) { double(:record) }
  let(:record_validator) { double(:record_validator) }
  let(:validator_options) { { validator_type: :a_method } }

  before do
    allow(store_proxy).to receive(:validator) { record_validator }
  end

  describe '#validate' do
    subject { validator.validate(store_proxy) }

    it 'calls the method specified by :validator_type' do
      expect(record_validator).to receive(:a_method).with(store_proxy)
        .and_return(true)
      subject
    end

    describe 'validator method returns' do
      let(:errors) { double(:record_errors) }

      before do
        allow(record_validator).to receive(:a_method).with(store_proxy)
          .and_return(is_valid)

        allow(store_proxy).to receive(:errors) { errors }
      end

      context 'true' do
        let(:is_valid) { true }

        it 'does not add any errors' do
          expect(store_proxy).to_not receive(:errors)
          subject
        end
      end

      context 'false' do
        let(:is_valid) { false }

        it 'adds an error' do
          expect(errors).to receive(:add).with(:base, '', validator_options)
          subject
        end
      end
    end
  end
end

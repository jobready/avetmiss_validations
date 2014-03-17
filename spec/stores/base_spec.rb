require 'spec_helper'

class PassingValidator < AvetmissValidations::Validator
  def validate
  end
end

class FailingValidator < AvetmissValidations::Validator
  def validate
    errors << {}
  end
end

describe AvetmissData::Stores::Base do
  let(:base_store) { AvetmissData::Stores::Base.new }

  context 'simple passing validator' do
    let(:validator) { PassingValidator.new(base_store) }
    specify { expect(validator.errors?).to be_false }
    specify { expect(validator.errors).to be_empty }
    specify { expect(validator.warnings?).to be_false }
    specify { expect(validator.warnings).to be_empty }
  end

  context 'simple failing validator' do
    let(:validator) { FailingValidator.new(base_store) }
    specify { expect(validator.errors?).to be_true }
    specify { expect(validator.errors).not_to be_empty }
    specify { expect(validator.warnings?).to be_false }
    specify { expect(validator.warnings).to be_empty }
    subject(:errors) { validator.errors }
    specify { expect(errors.first).to eq({}) }
  end

  context 'complex validator' do
    let(:base_store) { AvetmissData::Stores::Base.new(:) }
    let(:validator) { CompexValidator.new(base_store) }
    specify { expect(validator.errors?).to be_true }
    specify { expect(validator.errors).not_to be_empty }
    specify { expect(validator.warnings?).to be_false }
    specify { expect(validator.warnings).to be_empty }
    subject(:errors) { validator.errors }
    specify { expect(errors.first).to eq({}) }


=begin
  context '.validator' do
    before { AvetmissData::Stores::Base.validator = PassingValidator }
    specify { expect(base_store.validator).to eq(PassingValidator) }
  end

  specify { expect { base_store.errors? }.to raise_error AvetmissValidations::NotValidatedException }
  specify { expect { base_store.warnings? }.to raise_error AvetmissValidations::NotValidatedException }

  context 'has simple true validator' do
    before { AvetmissData::Stores::Base.validator = PassingValidator }
    specify { expect(base_store.errors?).to be_false }
    specify { expect(base_store.warnings?).to be_false }
  end

  context 'has simple false validator' do
    before { AvetmissData::Stores::Base.validator = FailingValidator }
    specify { expect(base_store.errors?).to be_true }
    specify { expect(base_store.warnings?).to be_false }
  end
=end
end

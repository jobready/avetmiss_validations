require 'spec_helper'

class SimpleValidator < AvetmissValidations::ActiveModel::Validator
  validates :foo, presence: true
end

describe AvetmissValidations::ActiveModel::Validator do
  let(:validator) { AvetmissValidations::ActiveModel::Validator.new(base_store) }

  before do
    AvetmissData::Stores::Base.nat_file('', {
      foo: 1..100
    })
  end

  context 'valid' do
    let(:base_store) { AvetmissData::Stores::Base.new(foo: '1234') }

    specify { expect(validator.fatals?).to be_false }
    specify { expect(validator.fatals).to be_empty }
    specify { expect(validator.warnings?).to be_false }
    specify { expect(validator.warnings).to be_empty }
  end

  context 'invalid' do
    let(:base_store) { AvetmissData::Stores::Base.new(foo: '') }

    specify { expect(validator.fatals?).to be_true }
    specify { expect(validator.fatals).not_to be_empty }
    specify { expect(validator.warnings?).to be_false }
    specify { expect(validator.warnings).to be_empty }
  end
end

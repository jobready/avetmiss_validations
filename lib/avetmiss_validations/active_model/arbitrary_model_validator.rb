class AvetmissValidations::ActiveModel::ArbitraryModelValidator < ActiveModel::Validator
  def validate(record)
    # options[:validator_type] is the method to call on the validator in this case
    unless record.validator.send(options[:validator_type], record)
      record.errors.add(:base, '',options)
    end
  end
end

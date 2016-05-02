class AvetmissValidations::ActiveModel::ArbitraryModelValidator < ActiveModel::Validator
  def validate(record)
    # options[:validator_type] is the method to call on the validator in this case
    unless record.validator.send(options[:validator_type], record)
      # Add an error to the record's base, rather than any specific attribute
      # This calls AvetmissValidations::ActiveModel::Errors#add, which calls
      # the validator's #add_result
      record.errors.add(:base, '',options)
    end

  end
end

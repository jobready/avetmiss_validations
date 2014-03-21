class AvetmissValidations::ActiveModel::Errors < ActiveModel::Errors
  def initialize(base, validator)
    super(base)
    @validator = validator
  end

  def add(attribute, message = nil, options = {})
    @validator.add_result({
      base: @base,
      attribute: attribute,
      value: @base.send(attribute),
      message: message,
      #normalize_message(attribute, message, options),
      validator_type: options[:validator_type]
    })
  end
end

class AvetmissValidations::ActiveModel::Errors < ActiveModel::Errors
  def initialize(base, validator)
    super(base)
    @validator = validator
  end

  def add(attribute, message = nil, options = {})
    value = attribute == :base ? '' : @base.send(attribute)

    @validator.add_result({
      base: @base,
      attribute: attribute,
      value: value,
      message: message,
      validator_type: options[:validator_type]
    })
  end
end

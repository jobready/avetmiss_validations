class AvetmissValidations::ActiveModel::Proxy < SimpleDelegator
  alias_method :object, :__getobj__

  attr_accessor :validator

  def initialize(store, validator)
    super(store)
    @validator = validator
    @errors = AvetmissValidations::ActiveModel::Errors.new(self, validator)
  end

  def errors
    @errors
  end

  alias_method :read_attribute_for_validation, :send
end

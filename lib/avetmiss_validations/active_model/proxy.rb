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

  def execute_in_context(procish_name, value)
    procish = if procish_name.is_a?(Symbol)
      method(procish_name)
    else
      procish_name
    end

    args = case procish.arity
    when 2
      [self, value]
    when 1
      [value]
    when 0, -1
      []
    else
      fail 'Wrong arity!'
    end

    instance_exec(*args, &procish)
  end
end

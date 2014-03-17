class AvetmissValidations::ActiveModel::Proxy < SimpleDelegator
  alias_method :object, :__getobj__

  def initialize(store, validator)
    super(store)
    @errors = AvetmissValidations::ActiveModel::Errors.new(self, validator)
  end

  def errors
    @errors
  end

  alias_method :read_attribute_for_validation, :send
=begin
  extend ActiveModel::Naming

  def self.model_name
    ActiveModel::Name.new(file_name)
  end
=end
end

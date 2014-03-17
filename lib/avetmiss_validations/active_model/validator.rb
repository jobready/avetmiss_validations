class AvetmissValidations::ActiveModel::Validator < AvetmissValidations::Validator
  class_attribute :attributes_validations
  self.attributes_validations = []

  def self.validates(attribute, validations)
    attributes_validations << { attribute: attribute, validations: validations }
  end

  def initialize(store)
    @store_proxy = AvetmissValidations::ActiveModel::Proxy.new(store, self)
    super(store)
  end

  def validate
    attributes_validations.each do |pair|
      apply_validations_on_attribute(pair[:attribute], pair[:validations])
    end
  end

  def apply_validations_on_attribute(attribute, validations)
    validations.each_pair do |type, options|
      options = active_model_class.send(:_parse_validates_options, options).merge(attributes: [attribute],
                                                                                  validator_type: type)
      validator_for_type(type).new(options).validate(@store_proxy)
    end
  end

  def add_result(result)
    fatals << result
  end

  private
  def validator_for_type(type)
    if type.to_s == 'arbitrary'
      AvetmissValidations::ActiveModel::ArbitraryValidator
    else
      "ActiveModel::Validations::#{type.to_s.camelize}Validator".constantize
    end
  end

  def active_model_class
    Class.new.include(ActiveModel::Validations::ClassMethods).new
  end
end


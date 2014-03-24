# TODO
class AvetmissValidations::ActiveModel::Validator < AvetmissValidations::Validator
  class << self
    attr_accessor :attributes_validations

    def attributes_validations
      @attributes_validations ||= []
    end

    def validates(attribute, validations)
      self.attributes_validations << { attribute: attribute, validations: validations }
    end
  end

  def initialize(store)
    @store_proxy = AvetmissValidations::ActiveModel::Proxy.new(store, self)
    super(store)
  end

  def validate
    self.class.attributes_validations.each do |pair|
      apply_validations_on_attribute(pair[:attribute], pair[:validations])
    end
  end

  def apply_validations_on_attribute(attribute, validations)
    validations.each_pair do |type, options|
      options = active_model_class.send(:_parse_validates_options, options).dup
      options.merge!(attributes: [attribute], validator_type: type, avetmiss_validator: self)

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


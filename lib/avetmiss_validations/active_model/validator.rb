# TODO
class AvetmissValidations::ActiveModel::Validator < AvetmissValidations::Validator
  class_attribute :attributes_validations
  self.attributes_validations = []

  def self.validates(attribute, validations)
    options = validations.extract!(:if, :unless)
    self.attributes_validations << { attribute: attribute, validations: validations, options: options }
  end

  def initialize(store)
    @store_proxy = AvetmissValidations::ActiveModel::Proxy.new(store, self)
    super(store)
  end

  def validate
    self.class.attributes_validations.each do |pair|
      apply_validations_on_attribute(pair[:attribute], pair[:validations], pair[:options])
    end
  end

  def apply_validations_on_attribute(attribute, validations, options)
    return unless should_validate?(attribute, options)

    validations.each_pair do |type, options|
      options = active_model_class.send(:_parse_validates_options, options).merge(
        attributes: [attribute], validator_type: type)

      validator_for_type(type).new(options).validate(@store_proxy)
    end
  end

  def should_validate?(attribute, options)
    if options[:if]
      return !!@store_proxy.execute_in_context(options[:if], @store_proxy.send(attribute))
    end
    if options[:unless]
      return !@store_proxy.execute_in_context(options[:unless], @store_proxy.send(attribute))
    end
    true
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


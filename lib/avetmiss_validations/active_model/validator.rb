class AvetmissValidations::ActiveModel::Validator < AvetmissValidations::Validator
  class_attribute :attributes_validations
  self.attributes_validations = []

  class_attribute :store_validations
  self.store_validations = []

  # Allows the caller to register validations on a single attibute
  def self.validates(attribute, validations)
    options = compact_validation_options(validations)
    self.attributes_validations += [{ attribute: attribute, validations: validations, options: options }]
  end

  # Allows the caller to register validations on the entire store
  def self.validate(validation_method, options={})
    options = compact_validation_options(options)
    self.store_validations += [{ validator_type: validation_method, options: options }]
  end

  # If/Unless keys from options with nil values stripped
  # Used to ensure consistent behaviour across ActiveSupport 3 and 4
  # (extract! doesn't return keys with nil values in AS4)
  def self.compact_validation_options(options)
    return options.extract!(:if, :unless).select { |key, value| value.present? }
  end

  def initialize(store)
    @store_proxy = AvetmissValidations::ActiveModel::Proxy.new(store, self)
    super(store)
  end

  def validate
    self.class.store_validations.each do |options|
      return unless should_validate?(options)
      AvetmissValidations::ActiveModel::ArbitraryModelValidator.new(options).validate(@store_proxy)
    end

    self.class.attributes_validations.each do |pair|
      apply_validations_on_attribute(pair[:attribute], pair[:validations], pair[:options])
    end
  end

  def apply_validations_on_attribute(attribute, validations, options)
    return unless should_validate?(options, attribute)

    validations.each_pair do |type, options|
      options = active_model_class.send(:_parse_validates_options, options).merge(
        attributes: [attribute], validator_type: type)

      validator_for_type(type).new(options).validate(@store_proxy)
    end
  end

  def should_validate?(options, attribute=nil)
    method_args = [store]
    method_args << store.send(attribute) unless attribute.nil?

    if options[:if]
      return !!send(options[:if], *method_args)
    end
    if options[:unless]
      return !send(options[:unless], *method_args)
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

require 'active_support/all'
require 'active_model'
require 'avetmiss_data'

require 'delegate'

module AvetmissValidations
  module ActiveModel
  end

  module Hierarchy
  end
end

require 'avetmiss_validations/validator'
require 'avetmiss_validations/active_model/arbitrary_validator'
require 'avetmiss_validations/active_model/errors'
require 'avetmiss_validations/active_model/proxy'
require 'avetmiss_validations/active_model/validator'

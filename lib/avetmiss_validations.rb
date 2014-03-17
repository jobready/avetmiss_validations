require 'active_support/all'
require 'active_model'
require 'avetmiss_data'

require 'delegate'

module AvetmissValidations
  module ActiveModel
  end
end

require 'avetmiss_validations/validator'
require 'avetmiss_validations/not_validated_exception'
require 'avetmiss_validations/active_model/arbitrary_validator'
require 'avetmiss_validations/active_model/errors'
require 'avetmiss_validations/active_model/proxy'
require 'avetmiss_validations/active_model/validator'

#require 'avetmiss_validations/package'
require 'avetmiss_validations/stores/base'
#require 'avetmiss_data/stores/rto_delivery_location'
#require 'avetmiss_data/stores/course'
#require 'avetmiss_data/stores/unit_of_competency'
#require 'avetmiss_data/stores/client'
#require 'avetmiss_data/stores/client_postal_detail'
#require 'avetmiss_data/stores/disability'
#require 'avetmiss_data/stores/achievement'
#require 'avetmiss_data/stores/enrolment'
#require 'avetmiss_data/stores/qual_completion'

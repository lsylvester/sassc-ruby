module SassC
  module Script
    def self.custom_functions
      Functions.instance_methods.select do |function|
        Functions.public_method_defined?(function)
      end
    end

    def self.formatted_function_name(function_name)
      params = Functions.instance_method(function_name).parameters
      params = params.map { |param_type, name| "$#{name}#{': null' if param_type == :opt}" }
                     .join(", ")

      "#{function_name}(#{params})"
    end

    module Value
    end
  end
end

require_relative "script/functions"
require_relative "script/value_conversion"

module Sass
  module Script
  end
end

require 'sassc/util'

require 'sassc/deprecation'

require 'sassc/script/value/base'
require 'sassc/script/value/string'
require 'sassc/script/value/color'
require 'sassc/script/value/bool'

SassC::Script::String = SassC::Script::Value::String
SassC::Script::Color = SassC::Script::Value::Color
SassC::Script::Bool = SassC::Script::Value::Bool

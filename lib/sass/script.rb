module Sass
  # SassScript is code that's embedded in Sass documents
  # to allow for property values to be computed from variables.
  #
  # This module contains code that handles the parsing and evaluation of SassScript.
  module Script

    require 'sass/script/tree'
    require 'sass/script/value'

    # @private
    CONST_RENAMES = {
      :Literal => Sass::Script::Value::Base,
      :ArgList => Sass::Script::Value::ArgList,
      :Bool => Sass::Script::Value::Bool,
      :Color => Sass::Script::Value::Color,
      :List => Sass::Script::Value::List,
      :Null => Sass::Script::Value::Null,
      :Number => Sass::Script::Value::Number,
      :String => Sass::Script::Value::String,
      :Node => Sass::Script::Tree::Node,
      :Funcall => Sass::Script::Tree::Funcall,
      :Interpolation => Sass::Script::Tree::Interpolation,
      :Operation => Sass::Script::Tree::Operation,
      :StringInterpolation => Sass::Script::Tree::StringInterpolation,
      :UnaryOperation => Sass::Script::Tree::UnaryOperation,
      :Variable => Sass::Script::Tree::Variable,
    }

    # @private
    def self.const_missing(name)
      klass = CONST_RENAMES[name]
      super unless klass
      CONST_RENAMES.each {|n, k| const_set(n, k)}
      klass
    end
  end
end

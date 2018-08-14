module SassC::Script::Value
  # The abstract superclass for SassScript objects.
  #
  # Many of these methods, especially the ones that correspond to SassScript operations,
  # are designed to be overridden by subclasses which may change the semantics somewhat.
  # The operations listed here are just the defaults.
  class Base
    # Returns the Ruby value of the value.
    # The type of this value varies based on the subclass.
    #
    # @return [Object]
    attr_reader :value

    # Creates a new value.
    #
    # @param value [Object] The object for \{#value}
    def initialize(value = nil)
      value.freeze unless value.nil? || value == true || value == false
      @value = value
      @options = nil
    end

    # Sets the options hash for this node,
    # as well as for all child nodes.
    # See {file:SASS_REFERENCE.md#Options the Sass options documentation}.
    #
    # @param options [{Symbol => Object}] The options
    attr_writer :options

    # Returns the options hash for this node.
    #
    # @return [{Symbol => Object}]
    # @raise [Sass::SyntaxError] if the options hash hasn't been set.
    #   This should only happen when the value was created
    #   outside of the parser and \{#to\_s} was called on it
    def options
      return @options if @options
      raise Sass::SyntaxError.new(<<MSG)
The #options attribute is not set on this #{self.class}.
  This error is probably occurring because #to_s was called
  on this value within a custom Sass function without first
  setting the #options attribute.
MSG
    end



  end
end

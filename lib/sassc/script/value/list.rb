module SassC::Script::Value
  # A SassScript object representing a CSS list.
  # This includes both comma-separated lists and space-separated lists.
  class List < Base
    # The Ruby array containing the contents of the list.
    #
    # @return [Array<Value>]
    attr_reader :value
    alias_method :to_a, :value

    # The operator separating the values of the list.
    # Either `:comma` or `:space`.
    #
    # @return [Symbol]
    attr_reader :separator

    # Whether the list is surrounded by square brackets.
    #
    # @return [Boolean]
    attr_reader :bracketed

    # Creates a new list.
    #
    # @param value [Array<Value>] See \{#value}
    # @param separator [Symbol] See \{#separator}
    # @param bracketed [Boolean] See \{#bracketed}
    def initialize(value, separator: nil, bracketed: false)
      super(value)
      @separator = separator
      @bracketed = bracketed
    end
  end
end

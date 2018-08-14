module SassC::Script::Value
  # A SassScript object representing a number.
  # SassScript numbers can have decimal values,
  # and can also have units.
  # For example, `12`, `1px`, and `10.45em`
  # are all valid values.
  #
  # Numbers can also have more complex units, such as `1px*em/in`.
  # These cannot be inputted directly in Sass code at the moment.
  class Number < Base


    # A list of units in the numerator of the number.
    # For example, `1px*em/in*cm` would return `["px", "em"]`
    # @return [Array<String>]
    attr_reader :numerator_units


    def self.precision
      Thread.current[:sass_numeric_precision] || Thread.main[:sass_numeric_precision] || 10
    end

    # the precision factor used in numeric output
    # it is derived from the `precision` method.
    def self.precision_factor
      Thread.current[:sass_numeric_precision_factor] ||= 10.0**precision
    end

    # Used in checking equality of floating point numbers. Any
    # numbers within an `epsilon` of each other are considered functionally equal.
    # The value for epsilon is one tenth of the current numeric precision.
    def self.epsilon
      Thread.current[:sass_numeric_epsilon] ||= 1 / (precision_factor * 10)
    end

    # Used so we don't allocate two new arrays for each new number.
    NO_UNITS = []

    # @param value [Numeric] The value of the number
    # @param numerator_units [::String, Array<::String>] See \{#numerator\_units}
    # @param denominator_units [::String, Array<::String>] See \{#denominator\_units}
    def initialize(value, numerator_units = NO_UNITS, denominator_units = NO_UNITS)
      numerator_units = [numerator_units] if numerator_units.is_a?(::String)
      denominator_units = [denominator_units] if denominator_units.is_a?(::String)
      super(value)
      @numerator_units = numerator_units
      @denominator_units = denominator_units
      @options = nil
      normalize!
    end

    # @return [Boolean] Whether or not this number has no units.
    def unitless?
      @numerator_units.empty? && @denominator_units.empty?
    end

    # Checks whether the number has the numerator unit specified.
    #
    # @example
    #   number = SassC::Script::Value::Number.new(10, "px")
    #   number.is_unit?("px") => true
    #   number.is_unit?(nil) => false
    #
    # @param unit [::String, nil] The unit the number should have or nil if the number
    #   should be unitless.
    # @see Number#unitless? The unitless? method may be more readable.
    def is_unit?(unit)
      if unit
        denominator_units.size == 0 && numerator_units.size == 1 && numerator_units.first == unit
      else
        unitless?
      end
    end

    # @param other [Number] A number to decide if it can be compared with this number.
    # @return [Boolean] Whether or not this number can be compared with the other.
    def comparable_to?(other)
      operate(other, :+)
      true
    rescue Sass::UnitConversionError
      false
    end

    private

    # @private
    # Checks whether two numbers are within an epsilon of each other.
    # @return [Boolean]
    def self.basically_equal?(num1, num2)
      (num1 - num2).abs < epsilon
    end

    def normalize!
      return if unitless?
      @numerator_units, @denominator_units =
        sans_common_units(@numerator_units, @denominator_units)

      @denominator_units.each_with_index do |d, i|
        next unless convertable?(d) && (u = @numerator_units.find {|n| convertable?([n, d])})
        @value /= conversion_factor(d, u)
        @denominator_units.delete_at(i)
        @numerator_units.delete_at(@numerator_units.index(u))
      end
    end

    def sans_common_units(units1, units2)
      units2 = units2.dup
      # Can't just use -, because we want px*px to coerce properly to px*mm
      units1 = units1.map do |u|
        j = units2.index(u)
        next u unless j
        units2.delete_at(j)
        nil
      end
      units1.compact!
      return units1, units2
    end
  end
end

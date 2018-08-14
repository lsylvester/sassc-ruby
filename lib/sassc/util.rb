# -*- coding: utf-8 -*-
require 'erb'
require 'set'
require 'enumerator'
require 'stringio'
require 'rbconfig'
require 'uri'
require 'thread'
require 'pathname'

module SassC
  # A module containing various useful functions.
  module Util
    extend self

    # Maps the values in a hash according to a block.
    #
    # @example
    #   map_values({:foo => "bar", :baz => "bang"}) {|v| v.to_sym}
    #     #=> {:foo => :bar, :baz => :bang}
    # @param hash [Hash] The hash to map
    # @yield [value] A block in which the values are transformed
    # @yieldparam value [Object] The value that should be mapped
    # @yieldreturn [Object] The new value for the value
    # @return [Hash] The mapped hash
    # @see #map_keys
    # @see #map_hash
    def map_vals(hash)
      # We don't delegate to map_hash for performance here
      # because map_hash does more than is necessary.
      rv = hash.class.new
      hash.each do |k, v|
        rv[k] = yield(v)
      end
      rv
    end

    # Restricts a number to falling within a given range.
    # Returns the number if it falls within the range,
    # or the closest value in the range if it doesn't.
    #
    # @param value [Numeric]
    # @param range [Range<Numeric>]
    # @return [Numeric]
    def restrict(value, range)
      [[value, range.first].max, range.last].min
    end

    # Like [Fixnum.round], but leaves rooms for slight floating-point
    # differences.
    #
    # @param value [Numeric]
    # @return [Numeric]
    def round(value)
      # If the number is within epsilon of X.5, round up (or down for negative
      # numbers).
      mod = value % 1
      mod_is_half = (mod - 0.5).abs < SassC::Script::Value::Number.epsilon
      if value > 0
        !mod_is_half && mod < 0.5 ? value.floor : value.ceil
      else
        mod_is_half || mod < 0.5 ? value.floor : value.ceil
      end
    end

  end
end

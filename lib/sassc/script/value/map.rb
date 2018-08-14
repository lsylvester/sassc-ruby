module SassC::Script::Value
  # A SassScript object representing a map from keys to values. Both keys and
  # values can be any SassScript object.
  class Map < Base
    # The Ruby hash containing the contents of this map.
    #
    # @return [Hash<Node, Node>]
    attr_reader :value
    alias_method :to_h, :value
  end
end

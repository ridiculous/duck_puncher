module DuckPuncher
  class UniqueDuck < DelegateClass(Duck)
    attr_accessor :punch_options

    #
    # Required to play nice in a Set
    #

    def eql?(other)
      "#{target}-#{mod}" == "#{other.target}-#{other.mod}"
    end

    def hash
      target.to_s.hash + mod.to_s.hash + punch_options.to_s.hash
    end

    #
    # Sorting
    #

    def <=>(other)
      target <=> other.target
    end

  end
end

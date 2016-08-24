module DuckPuncher
  class Duck
    attr_accessor :target, :mod, :options

    # @param target [String,Class] Class or module to punch
    # @param mod [String,Module] The module that defines the extensions (@name is used by default)
    # @param [Hash] options to modify the duck #punch method behavior
    # @option options :before [Proc] A hook that is called with the target class before +punch+
    # @option options :after [Proc] A hook that is called with the target class after +punch+
    def initialize(target, mod, options = {})
      @options = options
      @target = DuckPuncher.lookup_constant(target)
      @mod = DuckPuncher.lookup_constant(mod)
    end

    # @param [Hash] opts to modify punch
    # @option options [Class] :target Specifies the class to be punched
    # @option options [Array,Symbol] :only Specifies the methods to extend onto the current object
    # @option options [Symbol,String] :method Specifies if the methods should be included or prepended (:include)
    # @return [Class] The class that was just punched
    def punch(opts = {})
      opts = options.merge opts
      targets = Array(opts[:target] || self.target)
      targets.each do |target|
        options[:before].call(target) if options[:before]
        target.extend Usable
        target.usable mod, only: opts[:only], method: opts[:method]
        options[:after].call(target) if options[:after]
      end
      targets
    end

    #
    # Required to play nice in a Set
    #

    def eql?(other)
      "#{target}-#{mod}" == "#{other.target}-#{other.mod}"
    end

    def hash
      target.to_s.hash + mod.to_s.hash
    end

    #
    # Required for sorting
    #

    def <=>(other)
      target <=> other.target
    end
  end
end

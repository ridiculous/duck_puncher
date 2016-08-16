module DuckPuncher
  class Duck
    attr_accessor :target, :mod, :options

    # @todo test punching a module
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
      target = opts.delete(:target) || self.target
      Array(target).each do |klass|
        options[:before].call(klass) if options[:before]
        klass.extend Usable
        klass.usable mod, only: opts[:only], method: opts[:method]
        options[:after].call(klass) if options[:after]
      end
      target
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

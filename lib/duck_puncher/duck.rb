module DuckPuncher
  class Duck
    attr_accessor :target, :mod, :options

    # @param target [String,Class] Class or module to punch
    # @param mod [String,Module] The module that defines the extensions
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
    def call(opts = {})
      opts = options.merge(opts)
      targets = Array(opts[:target] || self.target)
      targets.each do |target|
        opts[:before].call(target) if opts[:before]
        punches = Array(opts[:only] || Ducks::Module.instance_method(:local_methods).bind(mod).call)
        unless target.is_a?(::Module)
          fail ArgumentError, "Invalid target #{target}. Please pass a module as :target"
        end
        DuckPuncher.logger.info %Q(#{target}#{" <-- #{mod.name}#{punches}" if punches.any?})
        extender = Usable::ModExtender.new(mod, only: opts.delete(:only), method: opts.delete(:method))
        extender.call target
        opts[:after].call(target) if opts[:after]
      end
      targets
    end

    alias punch call
  end
end

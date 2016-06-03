module DuckPuncher
  class Duck
    attr_accessor :name, :options

    # @param [Symbol] name of the duck
    # @param [Hash] options to modify the duck #punch method behavior
    # @option options [String,Module] :mod The module that defines the extensions (@name is used by default)
    # @option options [String,Class] :class (name) to punch
    # @option options [Proc] :if Stops +punch+ if it returns false
    # @option options [Proc] :before A hook that is called with the target class before +punch+
    # @option options [Proc] :after A hook that is called with the target class after +punch+
    def initialize(name, options = {})
      @name = name
      @options = options
    end

    # @param [Hash] opts to modify punch
    # @option options [Class] :target Specifies the class to be punched
    # @option options [Array,Symbol] :only Specifies the methods to extend onto the current object
    # @option options [Symbol,String] :method Specifies if the methods should be included or prepended (:include)
    # @return [Class] The class that was just punched
    def punch(opts = {})
      if options[:if] && !options[:if].call
        DuckPuncher.log.info %Q(Skipping the punch for #{name}!)
        return nil
      end
      if options[:mod]
        mod = lookup_constant(options[:mod])
      else
        mod = DuckPuncher::Ducks.const_get(name)
      end
      target = opts.delete(:target) || lookup_class
      Array(target).each do |klass|
        options[:before].call(klass) if options[:before]
        klass.extend Usable
        klass.usable mod, only: opts[:only], method: opts[:method]
        options[:after].call(klass) if options[:after]
      end
      target
    end

    # @return [Class] The class that is given to initialize as the option :class or the name of the current duck (module extension)
    def lookup_class
      lookup_constant(options[:class] || name)
    end

    def lookup_constant(const)
      return const if Module === const
      const.to_s.split('::').inject(Kernel) { |k, part| k.const_get(part) }
    end

    # @param [Class] obj The object being punched
    def delegated(obj = nil)
      obj_class = obj ? obj.class : lookup_class
      klass = DelegateClass(obj_class)
      punch target: klass, method: :prepend
      klass.usable DuckPuncher::Ducks::Object, only: :punch, method: :prepend
      klass
    end

    def classify
      Class.new(lookup_class).tap { |k| punch target: k }
    end
  end
end

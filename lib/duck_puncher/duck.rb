module DuckPuncher
  class Duck
    attr_accessor :name, :options

    # @param [Symbol] name of the duck
    # @param [Hash] options to modify the duck #punch method behavior
    # @option options [String] :class (name) to punch
    # @option options [Proc] :if Stops +punch+ if it returns false
    # @option options [Proc] :before A hook that is called with the target @klass before +punch+
    # @option options [Proc] :after A hook that is called with the target @klass after +punch+
    def initialize(name, options = {})
      @name = name
      @options = options
    end

    # @param [Hash] opts to modify punch
    # @option options [Class] :target Overrides the @klass to be punched
    # @option options [Array,Symbol] :only Specifies the methods to extend onto the current object
    def punch(opts = {})
      if options[:if] && !options[:if].call
        DuckPuncher.log.info %Q(Skipping the punch for #{name}!)
        return nil
      end
      target = opts.delete(:target) || klass
      options[:before].call(target) if options[:before]
      target.extend Usable
      target.usable DuckPuncher::Ducks.const_get(name), opts
      target
    end

    def klass
      @klass ||= (options[:class] || name).to_s.split('::').inject(Kernel) { |k, part| k.const_get part }
    end

    # @param [Class] obj The object being punched
    def delegated(obj = nil)
      obj_class = obj ? obj.class : klass
      klass = DelegateClass(obj_class)
      punch target: klass
      klass.usable DuckPuncher::Ducks::Object, only: :punch, method: :prepend
      klass
    end

    def classify
      Class.new(klass).tap { |k| punch target: k }
    end
  end
end

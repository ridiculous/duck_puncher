module DuckPuncher
  class Duck
    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options
      @punched = false
    end

    def load_path
      "duck_puncher/ducks/#{name.to_s.gsub(/\B([A-Z])/, '_\1').downcase}"
    end

    def punch(target = nil)
      if options[:if] && !options[:if].call
        DuckPuncher.log.warn %Q(Failed to punch #{name}!)
        return nil
      end
      options[:before].call if options[:before]
      (target || klass).send :include, DuckPuncher::Ducks.const_get(name)
      options[:after].call if options[:after]
      @punched = true
    end

    def klass
      @klass ||= (options[:class] || name).to_s.split('::').inject(Kernel) { |k, part| k.const_get part }
    end

    def punched?
      @punched
    end

    def delegated
      DelegateClass(klass).tap &method(:punch)
    end

    def classify
      Class.new(klass).tap &method(:punch)
    end
  end
end

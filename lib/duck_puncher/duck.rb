module DuckPuncher
  class Duck
    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options
    end

    def load_path
      "duck_puncher/ducks/#{name.to_s.gsub(/\B([A-Z])/, '_\1').downcase}"
    end

    def punch(opts = {})
      if options[:if] && !options[:if].call
        DuckPuncher.log.warn %Q(Failed to punch #{name}!)
        return nil
      end
      options[:before].call if options[:before]
      target = opts.delete(:target) || klass
      target.extend Usable
      target.usable DuckPuncher::Ducks.const_get(name), opts
      target
    end

    def klass
      @klass ||= (options[:class] || name).to_s.split('::').inject(Kernel) { |k, part| k.const_get part }
    end

    def delegated
      DelegateClass(klass).tap { |k| punch target: k }
    end

    def classify
      Class.new(klass).tap { |k| punch target: k }
    end
  end
end

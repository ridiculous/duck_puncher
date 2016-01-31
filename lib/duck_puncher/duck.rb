module DuckPuncher
  class Duck
    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options
      @punched = false
    end

    def load_path
      "duck_puncher/ducks/#{name.to_s.downcase}"
    end

    def punch(target = nil)
      return false if options[:if] && !options[:if].call
      options[:before].call if options[:before]
      (target || klass).send :include, DuckPuncher::Ducks.const_get(name)
      @punched = true
    end

    def klass
      @klass ||= (options[:class] || name).to_s.split('::').inject(Kernel) { |k, part| k.const_get part }
    end

    def punched?
      @punched
    end
  end
end

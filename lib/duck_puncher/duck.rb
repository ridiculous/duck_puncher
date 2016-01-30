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

    def punch
      return false if options[:if] && !options[:if].call
      options[:before].call if options[:before]
      const.send :include, DuckPuncher::Ducks.const_get(name)
      @punched = true
    end

    def const
      @const ||= (options[:class] || name).to_s.split('::').inject(Kernel) { |k, part| k.const_get part }
    end

    def punched?
      @punched
    end
  end
end

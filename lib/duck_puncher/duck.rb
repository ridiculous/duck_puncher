module DuckPuncher
  class Duck
    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options
      @punched = false
    end

    # @note Assumes the String duck is loaded first
    def load_path
      path_name = if name == :String
        name.to_s.downcase
      else
        Object.send(:punch, :String, name.to_s).underscore
      end
      "duck_puncher/ducks/#{path_name}"
    end

    def punch(target = nil)
      return false if options[:if] && !options[:if].call
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
      DelegateClass(klass).tap { |k| punch k }
    end
  end
end

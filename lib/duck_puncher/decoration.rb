module DuckPuncher
  # @note When updating this file please update comment regarding this module in duck_puncher.rb
  module Decoration
    def decorators
      @decorators ||= ancestral_hash
    end

    def build_decorator_class(*ducks)
      targets = ducks.sort.map(&:target)
      decorator_class = DelegateClass(targets.first)
      DuckPuncher.redefine_constant "#{targets.first.to_s.tr(':', '')}Delegator", decorator_class
      ducks.each { |duck| duck.punch target: decorator_class, method: :prepend }
      decorator_class
    end

    def decorate(context, target)
      cached_decorators[target].inject(context) { |me, (_, decorator)| decorator.new(me) }
    end

    def cached_decorators
      @cached_decorators ||= Hash.new do |me, target|
        me[target] = DuckPuncher.decorators.select { |klass, _| klass >= target }
      end
    end

    def undecorate(obj)
      obj = obj.__getobj__ while obj.respond_to? :__getobj__
      obj
    end
  end
end
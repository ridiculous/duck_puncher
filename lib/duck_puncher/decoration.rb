module DuckPuncher
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
      DuckPuncher.decorators
        .select { |klass, _| klass >= target }
        .sort { |a, b| b[0] <=> a[0] }
        .inject(context) { |me, (_, decorator)| decorator.new(me) }
    end

    def undecorate(obj)
      obj = obj.__getobj__ while obj.respond_to? :__getobj__
      obj
    end
  end
end
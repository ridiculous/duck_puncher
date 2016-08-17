module DuckPuncher
  module Decoration
    def decorators
      @decorators ||= ancestral_hash
    end

    def new_decorator(*ducks)
      targets = ducks.sort.map(&:target)
      decorator_class = DelegateClass(targets.first)
      DuckPuncher.redefine_constant "#{targets.first.to_s.tr(':', '')}Delegator", decorator_class
      ducks.each { |duck| duck.punch target: decorator_class, method: :prepend }
      decorator_class
    end

    def undecorate(obj)
      obj = obj.__getobj__ while obj.respond_to? :__getobj__
      obj
    end
  end
end
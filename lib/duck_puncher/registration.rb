module DuckPuncher
  # @note When updating this file please update comment regarding this module in duck_puncher.rb
  module Registration
    def register(target, *mods)
      options = mods.last.is_a?(Hash) ? mods.pop : {}
      target = DuckPuncher.lookup_constant target
      Ducks.list[target] = Set.new [] unless Ducks.list.key?(target)
      Array(mods).each do |mod|
        duck = UniqueDuck.new Duck.new target, mod, options
        Ducks.list[target] << duck
        decorators[target] = build_decorator_class(duck, *Ducks[target])
      end
      @cached_decorators = nil
    end

    def register!(*args)
      register *args
      call args.first
    end

    def deregister(*classes)
      classes.each &Ducks.list.method(:delete)
      classes.each &decorators.method(:delete)
      @cached_decorators = nil
    end
  end
end

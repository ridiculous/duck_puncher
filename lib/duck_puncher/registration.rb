module DuckPuncher
  module Registration
    def register(target, *mods)
      options = mods.last.is_a?(Hash) ? mods.pop : {}
      target = DuckPuncher.lookup_constant target
      Ducks.list[target] = [] unless Ducks.list.key?(target)
      Array(mods).each do |mod|
        duck = Duck.new target, mod, options
        Ducks.list[target] << duck
        decorators[target] = new_decorator(duck, *Ducks[target])
      end
      nil
    end

    def deregister(*classes)
      classes.each &Ducks.list.method(:delete)
      classes.each &decorators.method(:delete)
      nil
    end
  end
end

module DuckPuncher
  # @note When updating this file please update comment regarding this module in duck_puncher.rb
  module Registration
    # Register an extension with a target class
    # When given a block, the block is used to create an anonymous module
    # @param target [Class,Module,Object] constant or instance to extend
    # @param mods [Array<Module>] modules to extend or mix into the target. The last argument can be a hash of options to customize the extension
    # @option :only [Symbol, Array<Symbol>] list of methods to extend onto the target (the module must have these defined)
    # @option :method [Symbol,String] the method used to apply the module, e.g. :extend (:include)
    # @option :before [Proc] A hook that is called with the target class before #punch
    # @option :after [Proc] A hook that is called with the target class after #punch
    def register(target, *mods, &block)
      options = mods.last.is_a?(Hash) ? mods.pop : {}
      mods << Module.new(&block) if block
      target = DuckPuncher.lookup_constant target
      Ducks.list[target] = Set.new [] unless Ducks.list.key?(target)
      mods = Array(mods).each do |mod|
        duck = UniqueDuck.new Duck.new(target, mod, options)
        Ducks.list[target] << duck
      end
      [target, *mods]
    end

    # Register an extension and then immediately activate it
    # See #register for accepted arguments
    def register!(*args, &block)
      register *args, &block
      call args.first
    end

    # Remove extensions for a given class or list of classes
    def deregister(*targets)
      targets.each &Ducks.list.method(:delete)
      targets.each &decorators.method(:delete)
    end
  end
end

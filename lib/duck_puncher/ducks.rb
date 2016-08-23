module DuckPuncher
  module Ducks
    autoload :String, 'duck_puncher/ducks/string'
    autoload :Enumerable, 'duck_puncher/ducks/enumerable'
    autoload :Numeric, 'duck_puncher/ducks/numeric'
    autoload :Hash, 'duck_puncher/ducks/hash'
    autoload :Object, 'duck_puncher/ducks/object'
    autoload :Method, 'duck_puncher/ducks/method'
    autoload :ActiveRecord, 'duck_puncher/ducks/active_record'
    autoload :Module, 'duck_puncher/ducks/module'

    class << self
      def list
        @list ||= DuckPuncher.ancestral_hash
      end

      def [](klass)
        list[klass]
      end

      def load_mods(klass, loaded_mods: [])
        if klass.respond_to?(:superclass)
          load_mods(klass.superclass, loaded_mods: list[klass].to_a.map(&:mod) + loaded_mods)
        else
          loaded_mods
        end
      end
    end
  end
end

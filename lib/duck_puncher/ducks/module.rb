module DuckPuncher
  module Ducks
    module Module
      def local_methods
        instance_methods(false).concat constants(false)
                                         .map! { |c| const_get(c) }
                                         .keep_if { |c| c.respond_to?(:instance_methods) }
                                         .flat_map { |c| c.instance_methods(false) }
                                         .uniq
      end
    end
  end
end
module DuckPuncher
  module Ducks
    module String
      def pluralize(count)
        "#{self}#{'s' if count != 1}"
      end unless method_defined?(:pluralize)

      def underscore
        gsub(/\B([A-Z])([a-z_0-9])/, '_\1\2').gsub('::', '/').downcase
      end unless method_defined?(:underscore)

      module Refinement
        refine ::String do
          include ::DuckPuncher::Ducks::String
        end
      end
    end
  end
end

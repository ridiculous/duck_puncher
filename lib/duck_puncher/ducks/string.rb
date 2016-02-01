module DuckPuncher
  module Ducks
    module String
      def pluralize(count)
        "#{self}#{'s' if count != 1}"
      end unless method_defined?(:pluralize)

      def underscore
        gsub(/\B([A-Z])([a-z_0-9])/, '_\1\2').gsub('::', '/').downcase
      end unless method_defined?(:underscore)

      def to_boolean(strict = false)
        @boolean_map ||= begin
          truths, falsities = %w(true 1 yes y on), ['false', '0', 'no', 'n', 'off', '']
          ::Hash[truths.product([true]) + falsities.product([false])]
        end
        strict ? !downcase.in?(falsities) : !!@boolean_map[downcase]
      end
    end
  end
end

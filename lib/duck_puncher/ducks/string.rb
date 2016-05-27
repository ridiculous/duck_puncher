module DuckPuncher
  module Ducks
    module String
      BOOLEAN_MAP = ::Hash[%w(true 1 yes y on).product([true]) + ['false', '0', 'no', 'n', 'off', ''].product([false])].freeze

      def pluralize(count)
        "#{self}#{'s' if count != 1}"
      end unless method_defined?(:pluralize)

      def underscore
        gsub(/\B([A-Z])([a-z_0-9])/, '_\1\2').gsub('::', '/').downcase
      end unless method_defined?(:underscore)

      def to_boolean
        !!BOOLEAN_MAP[downcase]
      end unless method_defined?(:to_boolean)
    end
  end
end

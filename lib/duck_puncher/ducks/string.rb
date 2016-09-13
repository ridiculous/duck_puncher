module DuckPuncher
  module Ducks
    module String
      BOOLEAN_MAP = ::Hash[%w(true 1 yes y on).product([true])].freeze

      def pluralize(count)
        "#{self}#{'s' if count != 1}"
      end unless method_defined?(:pluralize)

      def underscore
        gsub(/\B([A-Z])([a-z_0-9])/, '_\1\2').gsub('::', '/').downcase
      end unless method_defined?(:underscore)

      def to_boolean
        !!BOOLEAN_MAP[downcase]
      end unless method_defined?(:to_boolean)

      def constantize
        split('::').inject(Object) { |o, name| o.const_get name }
      end unless method_defined?(:constantize)
    end
  end
end

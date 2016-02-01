module DuckPuncher
  module Ducks
    module Hash
      # http://coryodaniel.com/index.php/2009/12/30/ruby-getting-deeply-nested-values-from-a-hash-in-one-line-of-code/
      def dig(*_keys_)
        last_level = self
        sought_value = nil
        _keys_.each_with_index do |_key_, _idx_|
          break unless last_level.respond_to?(:has_key?)
          break unless last_level.has_key?(_key_)
          if _idx_ + 1 == _keys_.length
            sought_value = last_level[_key_]
          else
            last_level = last_level[_key_]
          end
        end

        sought_value
      end unless method_defined?(:dig)
    end
  end
end

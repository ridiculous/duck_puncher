module DuckPuncher
  module Hash
    # http://coryodaniel.com/index.php/2009/12/30/ruby-getting-deeply-nested-values-from-a-hash-in-one-line-of-code/
    def seek(*_keys_)
      last_level = self
      sought_value = nil

      _keys_.each_with_index do |_key_, _idx_|
        if last_level.is_a?(Hash) && last_level.has_key?(_key_)
          if _idx_ + 1 == _keys_.length
            sought_value = last_level[_key_]
          else
            last_level = last_level[_key_]
          end
        else
          break
        end
      end

      sought_value
    end
  end
end

Hash.send(:include, DuckPuncher::Hash)
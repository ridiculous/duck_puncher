module DuckPuncher
  # @note When updating this file please update comment regarding this module in duck_puncher.rb
  module AncestralHash
    def ancestral_hash
      ::Hash.new { |me, klass| me[me.keys.detect { |key| key > klass }] if klass }
    end
  end
end

module DuckPuncher
  module Numeric
    def to_currency
      '%.2f' % self.round(2)
    end
  end
end

Numeric.send(:include, DuckPuncher::Numeric)
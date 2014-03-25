module DuckPuncher
  module Numeric
    def to_currency
      '%.2f' % self.round(2)
    end

    def to_duration(seconds=false)
      secs = self.to_i
      mins = secs / 60
      hours = mins / 60
      buffer = ''
      if hours > 0
        num_mins = mins % 60
        buffer << "#{hours} h"
        buffer << " #{num_mins} min" unless num_mins.zero?
      elsif mins > 0
        num_secs = secs % 60
        buffer << "#{mins} min"
        buffer << " #{num_secs} s" if seconds && num_secs.nonzero?
      elsif seconds && secs >= 0
        buffer << "#{secs} s"
      end
      buffer
    end
  end
end

Numeric.send(:include, DuckPuncher::Numeric)
module DuckPuncher
  module Numeric
    def to_currency(prefix = '')
      "#{prefix}%.2f" % self.round(2)
    end

    def to_duration(seconds = false)
      secs = to_i
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

    def to_time_ago
      secs = to_i
      mins = secs / 60
      hours = mins / 60
      days = hours / 24
      buffer = ''
      if days > 0
        buffer << "#{days} #{'day'.pluralize(days)}"
      elsif hours > 0
        buffer << "#{hours} #{'hour'.pluralize(hours)}"
      elsif mins > 0
        buffer << "#{mins} #{'minute'.pluralize(mins)}"
      elsif secs >= 0
        buffer << "less than a minute"
      end
      buffer << ' ago'
    end

    def to_rad
      self / 180 * Math::PI
    end
  end
end

Numeric.send(:include, DuckPuncher::Numeric)
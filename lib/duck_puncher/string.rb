module DuckPuncher
  module String
    def pluralize(count)
      "#{self}#{'s' if count != 1}"
    end
  end
end

String.send(:include, DuckPuncher::String)
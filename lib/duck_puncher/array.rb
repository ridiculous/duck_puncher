module DuckPuncher
  module Array
    def m(method_name)
      map(&method_name)
    end

    def mm(method_name, *args)
      map { |x| x.public_send(method_name, *args) }
    end

    def get(regex_or_str)
      regex = regex_or_str.is_a?(Regexp) ? regex_or_str : Regexp.new(Regexp.escape(regex_or_str))
      select { |x| x.to_s =~ regex }
    end
  end
end

Array.send(:include, DuckPuncher::Array)

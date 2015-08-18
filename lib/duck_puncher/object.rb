module DuckPuncher
  module Object
    def clone!
      Marshal.load Marshal.dump self
    end unless defined? clone!
  end
end

Object.send(:include, DuckPuncher::Object)

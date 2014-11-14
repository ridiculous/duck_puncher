module DuckPuncher
   module Array
     def m(method_name)
       self.map(&method_name)
     end
   end
end

Array.send(:include, DuckPuncher::Array)

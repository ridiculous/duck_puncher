module DuckPuncher
  module Ducks
    module Array
      def m(method_name)
        map(&method_name)
      end

      def mm(method_name, *args)
        map { |x| x.public_send(method_name, *args) }
      end

      def except(*args)
        self - args
      end
    end
  end
end


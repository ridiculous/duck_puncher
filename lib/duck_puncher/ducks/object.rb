module DuckPuncher
  module Ducks
    module Object
      def clone!
        Marshal.load Marshal.dump self
      end unless defined? clone!

      def require!(file_or_gem, version = '')
        if DuckPuncher::GemInstaller.new.perform(file_or_gem, version)
          require file_or_gem.tr('-', '/')
        end
      end

      def punch(klass_name = nil)
        klass_name ||= self.class.name
        DuckPuncher.delegate_class(klass_name.to_sym).new(self)
      end

      def track
        require! 'object_tracker'
        extend ::ObjectTracker
        track_all!
      end
    end
  end
end

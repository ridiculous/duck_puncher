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

      # @description Returns a new decorated version of ourself with the punches mixed in (adds ancestors decorators)
      # @return [<self.class>Delegator]
      def punch
        DuckPuncher.decorate self, DuckPuncher.undecorate(self).class
      end

      # @description Adds the duck punches to the current object (meant to be used on instances, careful with nil and numbers!)
      # @return self
      def punch!
        target = DuckPuncher.undecorate(self).class
        DuckPuncher::Ducks.load_mods(target).each { |mod| self.extend mod }
        self
      end

      def echo
        puts 'ECHO ' + ('(' * 14)
        p self
        puts '', caller_locations.take(5).map { |l| l.to_s.prepend('  * ') }.join("\n"), 'END'
        self
      end

      def track
        begin
          require 'object_tracker' || raise(LoadError)
        rescue LoadError
          DuckPuncher.(Object, only: :require!) unless respond_to? :require!
          require! 'object_tracker'
        end
        extend ::ObjectTracker
        track_all!
      end
    end
  end
end

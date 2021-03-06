module DuckPuncher
  module Ducks
    module Object
      def clone!
        Marshal.load Marshal.dump self
      end unless defined? clone!

      def require!(file_or_gem, version = '', patience: 1)
        if DuckPuncher::GemInstaller.new.perform(file_or_gem, version)
          if require file_or_gem.tr('-', '/')
            true
          elsif patience > 0
            sleep 0.005
            require!(file_or_gem, version, patience: patience - 1)
          end
        end
      rescue ::LoadError
        require!(file_or_gem, version, patience: patience - 1) unless patience.zero?
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

      # @param [Integer] trace The number of lines from the stack trace to print (nil)
      def echo(trace = nil)
        p self
        puts caller_locations.take(trace).map { |l| l.to_s.prepend('* ') }.join("\n") if trace
        self
      end

      def track!(patience: 1)
        begin
          require 'object_tracker' || raise(::LoadError)
        rescue ::LoadError
          DuckPuncher.(Object, only: :require!) unless respond_to? :require!
          require! 'object_tracker'
        end
        ::ObjectTracker.(self)
      rescue ::Exception
        sleep 0.005
        track!(patience: patience - 1) unless patience.zero?
      end
    end
  end
end

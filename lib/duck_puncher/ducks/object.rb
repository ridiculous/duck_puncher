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
        target = DuckPuncher.undecorate(self).class
        targets = DuckPuncher.decorators.select { |klass, _| klass >= target }.sort { |a, b| b[0] <=> a[0] }
        targets.inject(self) { |context, (_, decorator)| decorator.new(context) }
      end

      # @description Adds the duck punches to the current object (meant to be used on instances, careful with nil and numbers!)
      # @return self
      def punch!
        target = DuckPuncher.undecorate(self).class
        DuckPuncher::Ducks.load_mods(target).each { |mod| self.extend mod }
        self
      end

      def echo
        p "#{self} -- #{caller_locations[respond_to?(:__getobj__) ? 2 : 0]}"
        self
      end

      def track
        begin
          require 'object_tracker' || raise(LoadError)
        rescue LoadError
          DuckPuncher.punch! Object, only: :require! unless respond_to? :require!
          require! 'object_tracker'
        end
        extend ::ObjectTracker
        track_all!
      end
    end
  end
end

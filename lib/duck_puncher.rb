# Standard lib
require 'pathname'
require 'fileutils'
require 'logger'
require 'set'
require 'delegate'

# Gems
require 'usable'

# Our stuff
require 'duck_puncher/version'
require 'duck_puncher/registration'
require 'duck_puncher/decoration'

module DuckPuncher
  autoload :JSONStorage, 'duck_puncher/json_storage'
  autoload :GemInstaller, 'duck_puncher/gem_installer'
  autoload :Duck, 'duck_puncher/duck'
  autoload :Ducks, 'duck_puncher/ducks'

  class << self
    include Registration, Decoration

    attr_accessor :log
    alias_method :logger, :log

    def punch!(*classes)
      options = classes.last.is_a?(Hash) ? classes.pop : {}
      classes.each do |klass|
        klass = lookup_constant(klass)
        Ducks[klass].sort.each do |duck|
          punches = options[:only] || Ducks::Module.instance_method(:local_methods).bind(duck.mod).call
          log.info %Q(#{duck.target}#{" <-- #{punches}" if Array(punches).any?})
          options[:target] = klass
          unless duck.punch(options)
            log.error %Q(Failed to punch #{name})
          end
        end
      end
      nil
    end

    def punch_all!
      punch! *Ducks.list.keys
    end

    def lookup_constant(const)
      return const if Module === const
      if const.to_s.respond_to?(:constantize)
        const.to_s.constantize
      else
        const.to_s.split('::').inject(Object) { |k, part| k.const_get(part) }
      end
    rescue NameError => e
      log.error "#{e.class}: #{e.message}"
      nil
    end

    def redefine_constant(name, const)
      if const_defined? name
        remove_const name
      end
      const_set name, const
    end

    def ancestral_hash
      Hash.new { |me, klass| me[klass.superclass] if klass.respond_to?(:superclass) }
    end
  end

  self.log = Logger.new(STDOUT).tap do |config|
    config.level = Logger::INFO
    config.formatter = proc { |*args| "#{args.first}: #{args.last.to_s}\n" }
  end

  log.level = Logger::ERROR

  ducks = [
    [String, Ducks::String],
    [Array, Ducks::Array],
    [Numeric, Ducks::Numeric],
    [Hash, Ducks::Hash],
    [Object, Ducks::Object],
    [Module, Ducks::Module],
    [Method, Ducks::Method, { before: ->(*) { DuckPuncher::GemInstaller.initialize! } }],
  ]
  ducks << ['ActiveRecord::Base', Ducks::ActiveRecord] if defined? ::ActiveRecord
  ducks.each do |duck|
    register *duck
  end
end

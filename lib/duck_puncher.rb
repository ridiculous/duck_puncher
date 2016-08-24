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
require 'duck_puncher/utilities'
require 'duck_puncher/ancestral_hash'
require 'duck_puncher/duck'
require 'duck_puncher/ducks'

module DuckPuncher
  autoload :GemInstaller, 'duck_puncher/gem_installer'
  autoload :JSONStorage, 'duck_puncher/json_storage'

  class << self
    # @description Include additional functionality
    #   Registration[:register, :deregister]
    #   Decoration[:decorators, :build_decorator_class, :decorate, :cached_decorators, :undecorate]
    #   Utilities[:lookup_constant, :redefine_constant]
    #   AncestralHash[:ancestral_hash]
    include Registration, Decoration, Utilities, AncestralHash

    attr_accessor :logger

    # Backwards compatibility
    alias_method :log, :logger
    alias_method :log=, :logger=

    def call(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      classes = args.any? ? args : Ducks.list.keys
      classes.each do |klass|
        klass = lookup_constant(klass)
        Ducks[klass].sort.each do |duck|
          punches = options[:only] || Ducks::Module.instance_method(:local_methods).bind(duck.mod).call
          options[:target] = klass
          log.info %Q(#{klass}#{" <-- #{duck.mod.name}#{punches}" if Array(punches).any?})
          unless duck.punch(options)
            log.error %Q(Failed to punch #{name})
          end
        end
      end
      nil
    end

    # Backwards compatibility
    alias punch_all! call
    alias punch! call
  end
end

# Everyone likes defaults
require 'duck_puncher/defaults'

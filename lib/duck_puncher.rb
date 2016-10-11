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
require 'duck_puncher/unique_duck'

module DuckPuncher
  autoload :GemInstaller, 'duck_puncher/gem_installer'
  autoload :JSONStorage, 'duck_puncher/json_storage'

  class << self
    # @description Include additional functionality
    include Registration    # [:register, :deregister]
    include Decoration      # [:decorators, :build_decorator_class, :decorate, :cached_decorators, :undecorate]
    include Utilities       # [:lookup_constant, :redefine_constant]
    include AncestralHash   # [:ancestral_hash]

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
          duck.punch_options = Ducks::Object.instance_method(:clone!).bind(options).call
          duck.punch_options[:target] ||= klass
          if punched_ducks.include?(duck)
            logger.warn %(Already punched #{duck.mod.name})
          elsif duck.punch(duck.punch_options).any?
            punched_ducks << duck
          else
            logger.warn %(No punches were thrown)
          end
        end
      end
      nil
    end

    # Backwards compatibility
    alias punch_all! call
    alias punch! call

    def punched_ducks
      @punched_ducks ||= Set.new
    end

    def register(*)
      target, *_ = super
      decorators[target] = build_decorator_class(*Ducks[target])
      @cached_decorators = nil
    end

    def deregister(*)
      super
      @cached_decorators = nil
    end
  end
end

# Everyone likes defaults
require 'duck_puncher/defaults'

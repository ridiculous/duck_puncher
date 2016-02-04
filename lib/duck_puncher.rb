require 'pathname'
require 'fileutils'
require 'delegate'
require 'logger'
require 'usable'
require 'duck_puncher/version'

module DuckPuncher
  autoload :JSONStorage, 'duck_puncher/json_storage'
  autoload :GemInstaller, 'duck_puncher/gem_installer'
  autoload :Duck, 'duck_puncher/duck'
  autoload :Ducks, 'duck_puncher/ducks'

  class << self
    attr_accessor :log

    def delegate_class(name)
      @delegations ||= {}
      @delegations[name] ||= Ducks[name].dup.delegated
    end

    # @description Extends functionality to a copy of the specified class
    def punch(*names)
      singular = names.size == 1
      punched_ducks = names.map { |name| Ducks[name].dup.classify }.compact
      punched_ducks = punched_ducks.first if singular
      punched_ducks
    end

    def punch!(*names)
      options = names.last.is_a?(Hash) ? names.pop : {}
      names.each do |name|
        duck = Ducks[name]
        log.warn %Q(Punching #{name} ducky)
        unless duck.punch(options)
          log.error %Q(Failed to punch #{name}!)
        end
      end
      nil
    end

    def punch_all!
      log.warn 'Punching all ducks! Watch out!'
      Ducks.list.each &:punch
    end
  end

  # @description Default logger
  # @example Silence logging
  #
  #   `DuckPuncher.log.level = Logger::ERROR`
  #
  self.log = Logger.new(STDOUT).tap do |config|
    config.level = Logger::INFO
    config.formatter = proc { |*args| "#{args.first}: #{args.last.to_s}\n" }
  end
end

DuckPuncher.logger = Logger.new(STDOUT).tap do |config|
  config.formatter = proc { |*args| "[DuckPuncher] #{args[0]}: #{args[-1]}\n" }
  config.level = Logger::ERROR
end

ducks = [
  [String, DuckPuncher::Ducks::String],
  [Enumerable, DuckPuncher::Ducks::Enumerable, {
    # Re-include Enumerable in these classes to pick up the new extensions
    after: proc {
      [Array, Set, Range, Enumerator].each do |k|
        DuckPuncher.logger.debug("Sending include to #{k} with Enumerable") and k.send(:include, Enumerable)
      end
    }
  }],
  [Numeric, DuckPuncher::Ducks::Numeric],
  [Hash, DuckPuncher::Ducks::Hash],
  [Object, DuckPuncher::Ducks::Object],
  [Module, DuckPuncher::Ducks::Module],
  [Method, DuckPuncher::Ducks::Method, { before: ->(_target) { DuckPuncher::GemInstaller.initialize! } }],
]
ducks << ['ActiveRecord::Base', DuckPuncher::Ducks::ActiveRecord] if defined? ::ActiveRecord
ducks.each do |duck|
  DuckPuncher.register *duck
end
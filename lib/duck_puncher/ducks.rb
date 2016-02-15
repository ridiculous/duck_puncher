module DuckPuncher
  module Ducks
    class << self
      def list
        @list ||= [
          Duck.new(:String),
          Duck.new(:Array),
          Duck.new(:Numeric),
          Duck.new(:Hash),
          Duck.new(:Object),
          Duck.new(:Method, before: ->(*) { DuckPuncher::GemInstaller.initialize! }),
          Duck.new(:ActiveRecord, class: 'ActiveRecord::Base', if: -> { defined? ::ActiveRecord })
        ]
      end

      def [](name)
        list.find { |duck| duck.name == name.to_sym } ||
          DuckPuncher.log.info(%Q(Couldn't find "#{name}" in my list of Ducks! I know about: #{list.map(&:name).map(&:to_s)}))
      end

      def load_path_for(duck)
        "duck_puncher/ducks/#{duck.name.to_s.gsub(/\B([A-Z])/, '_\1').downcase}"
      end
    end

    #
    # Autoload our ducks
    #

    list.each do |duck|
      autoload duck.name, load_path_for(duck)
    end
  end
end

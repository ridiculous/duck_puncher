require_relative 'json_storage'
require_relative 'gem_installer'

module DuckPuncher
  module Object
    include DuckPuncher::GemInstaller::LoadPathInitializer

    def clone!
      Marshal.load Marshal.dump self
    end unless defined? clone!

    def require!(file_or_gem, version = '')
      if DuckPuncher::GemInstaller.new.perform(file_or_gem, version)
        require file_or_gem.tr('-', '/')
      end
    end
  end
end

Object.send(:include, DuckPuncher::Object)

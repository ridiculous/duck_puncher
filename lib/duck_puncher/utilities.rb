module DuckPuncher
  # @note When updating this file please update comment regarding this module in duck_puncher.rb
  module Utilities
    def lookup_constant(const)
      return const if ::Module === const
      if const.to_s.respond_to?(:constantize)
        const.to_s.constantize
      else
        const.to_s.split('::').inject(::Object) { |k, part| k.const_get(part) }
      end
    rescue ::NameError => e
      log.error "#{e.class}: #{e.message}"
      nil
    end

    def redefine_constant(name, const)
      if const_defined? name
        remove_const name
      end
      const_set name, const
    end
  end
end

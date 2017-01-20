module DuckPuncher
  module Ducks
    module ActiveRecord
      def self.included(base)
        base.extend(ClassMethods)
      end

      def associations?
        associations.present?
      end

      def associations
        results = []
        refls = send respond_to?(:reflections) ? :reflections : :_reflections
        refls.each do |key, reflection|
          begin
            if reflection.macro.to_s =~ /many/ ? public_send(key).exists? : public_send(key).present?
              results << key
            end
          rescue
            nil
          end
        end
        results
      end

      module ClassMethods
        def except_for(*ids)
          scoped.where("#{quoted_table_name}.#{primary_key} NOT IN (?)", ids)
        end

        def since(time)
          scoped.where("#{quoted_table_name}.created_at > ?", time)
        end

        alias created_since since

        def before(time)
          scoped.where("#{quoted_table_name}.created_at < ?", time)
        end

        def updated_since(time)
          scoped.where("#{quoted_table_name}.updated_at > ?", time)
        end

        def between(start_at, end_at)
          scoped.where("#{quoted_table_name}.created_at BETWEEN ? AND ", start_at, end_at)
        end

        # shim for backwards compatibility with Rails 3
        def scoped
          where(nil)
        end if ::Rails::VERSION::MAJOR > 3
      end
    end
  end
end

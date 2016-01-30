module DuckPuncher
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end

    def associations?
      associations.present?
    end

    def associations
      reflections.select { |key, _| send(key).present? rescue nil }.keys
    end

    module ClassMethods
      def except_for(*ids)
        scoped.where("#{quoted_table_name}.id NOT IN (?)", ids)
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

      def latest
        scoped.order("#{quoted_table_name}.id ASC").last
      end

      # shim for backwards compatibility with Rails 3
      def scoped
        where(nil)
      end if Rails::VERSION::MAJOR != 3
    end
  end
end

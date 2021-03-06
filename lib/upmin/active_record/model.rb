module Upmin::ActiveRecord
  module Model
    extend ActiveSupport::Concern

    def new_record?
      return model.new_record?
    end

    def to_key
      return model.to_key
    end


    module ClassMethods
      # NOTE - ANY method added here must be added to the bottom of
      # Upmin::Model. This ensures that an instance of the class was
      # created, which in turn ensures that the correct module was
      # included in the class.

      def find(*args)
        return model_class.find(*args)
      end

      def default_attributes
        return model_class.attribute_names.map(&:to_sym)
      end

      def attribute_type(attribute)
        adapter = model_class.columns_hash[attribute.to_s]
        return adapter.type if adapter
        return :unknown
      end

      def associations
        return @associations if defined?(@associations)

        all = []
        ignored = []
        model_class.reflect_on_all_associations.each do |reflection|
          all << reflection.name.to_sym

          # We need to remove the ignored later because we don't know the order they come in.
          if reflection.is_a?(::ActiveRecord::Reflection::ThroughReflection)
            ignored << reflection.options[:through]
          end
        end

        return @associations = (all - ignored).uniq
      end

    end

  end
end

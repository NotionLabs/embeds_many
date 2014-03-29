module EmbedsMany
  module Base
    def embeds_many(field)
      child_klass = instance_variable_set "@#{field}_klass", EmbedsMany::Child.clone
      child_klass.instance_variable_set "@field_name", field

      # rewrite association
      define_method field do
        instance_variable_get("@#{field}_collection") ||
          instance_variable_set("@#{field}_collection", ChildrenCollection.new(self, field, child_klass))
      end
    end

    # define validations and helper instance methods
    def embedded(field, &block)
      child_klass = instance_variable_get "@#{field}_klass"
      child_klass.class_eval(&block)
    end
  end
end

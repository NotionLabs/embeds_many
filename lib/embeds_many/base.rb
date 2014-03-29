module EmbedsMany
  module Base
    def embeds_many(field, &block)
      child_klass =  Class.new(EmbedsMany::Child)
      child_klass.instance_variable_set "@field_name", field

      # rewrite association
      define_method field do
        instance_variable_get("@#{field}_collection") ||
          instance_variable_set("@#{field}_collection", ChildrenCollection.new(self, field, child_klass))
      end

      child_klass.class_eval(&block) if block
    end
  end
end

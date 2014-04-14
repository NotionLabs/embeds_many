module EmbedsMany
  class ChildrenCollection
    def new(attrs={})
      record = @child_klass.new(attrs.merge(parent: @obj))
      @created_instances << record

      record
    end

    def create(attrs={})
      record = @child_klass.new(attrs.merge(parent: @obj))

      record.save

      @created_instances << record

      record
    end

    def initialize(obj, field, child_klass)
      @obj = obj
      @field = field
      @child_klass = child_klass
      @created_instances = []
    end

    def find(id)
      attrs = @obj.read_attribute(@field).find {|child| child['id'].to_i == id.to_i }

      if attrs
        record = @child_klass.new(attrs.merge(parent: @obj))
        @created_instances << record

        record
      end
    end

    # all records
    def all
      @obj.read_attribute(@field).map do |attrs|
        @child_klass.new(attrs.merge(parent: @obj))
      end
    end

    # called before parent save
    def before_parent_save
      @created_instances.map(&:before_parent_save)
    end

    # child destroyed
    def child_destroyed(child)
      @created_instances.delete(child)
    end

    # pass unhandled message to children array
    def method_missing(symbol, *args, &block)
      all.send(symbol, *args, &block)
    end
  end
end

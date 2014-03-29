module EmbedsMany
  class ChildrenCollection
    def new(attrs)
      @child_klass.new(attrs.merge(parent: @obj))
    end

    def create(attrs)
      record = @child_klass.new(attrs.merge(parent: @obj))

      record.save

      record
    end

    def initialize(obj, field, child_klass)
      @obj = obj
      @field = field
      @child_klass = child_klass
    end

    def find(id)
      attrs = @obj.read_attribute(@field).find {|child| child['id'].to_i == id.to_i }

      attrs && @child_klass.new(attrs.merge(parent: @obj))
    end

    # all records
    def all
      @obj.read_attribute(@field).map do |attrs|
        @child_klass.new(attrs.merge(parent: @obj))
      end
    end

    # pass unhandled message to children array
    def method_missing(symbol, *args, &block)
      all.send(symbol, *args, &block)
    end
  end
end
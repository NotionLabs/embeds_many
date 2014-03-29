module EmbedsMany
  class Child
    extend ActiveModel::Validations::ClassMethods
    include ActiveModel::Dirty
    include ActiveModel::Validations

    # add accessors for fields
    def self.embedded_fields(*fields)
      fields.each do |field_name|
        define_method(field_name) do
          @attributes[field_name]
        end

        define_method("#{field_name}=") do |val|
          @attributes[field_name] = val
        end
      end
    end

    attr_accessor :parent
    embedded_fields :id

    class UniquenessValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if record.exists_in_parent? {|item| item.key?(attribute.to_s) && item[attribute.to_s] == value && record.id.to_s != item['id'] }
          record.errors.add attribute, "#{value} is already taken"
        end
      end
    end

    # validation requires model name
    def self.model_name
      ActiveModel::Name.new(self, nil, self.name || @field_name.to_s.classify)
    end

    def initialize(attrs={})
      @attributes = ActiveSupport::HashWithIndifferentAccess.new

      attrs.each do |name, value|
        if respond_to? "#{name}="
          send("#{name}=", value)
        else
          @attributes[name] = value
        end
      end
    end

    def save
      return false unless self.valid?

      if new_record?
        save_new_record!
      else
        save_existing_record!
      end
    end

    def destroy
      # tell rails the field will change
      parent.send "#{field_name}_will_change!"

      parent.read_attribute(field_name).delete_if {|t| t['id'] == self.id}

      if parent.save
        true
      else
        parent.send "#{field_name}=", parent.send("#{field_name}_was")
        false
      end
    end

    def update(attrs)
      @attributes.update(attrs)

      save
    end

    def new_record?
      self.id.nil?
    end

    def exists_in_parent?(&block)
      parent.read_attribute(field_name).any? &block
    end

    private

    def save_new_record!
      @attributes[:id] = generate_id!

      # tell rails the field will change
      parent.send "#{field_name}_will_change!"

      parent.read_attribute(field_name) << @attributes.to_hash

      if parent.save
        true
      else
        @attributes.id = nil
        # restore old value
        parent.send "#{field_name}=", parent.send("#{field_name}_was")
        false
      end
    end

    def save_existing_record!
      # tell rails the field will change
      parent.send "#{field_name}_will_change!"

      record = parent.read_attribute(field_name).detect {|t| t['id'].to_i == self.id.to_i }
      record.merge!(@attributes)

      if parent.save
        true
      else
        # restore old value
        parent.send "#{field_name}=", parent.send("#{field_name}_was")
        false
      end
    end

    def generate_id!
      max_id = parent.read_attribute(field_name).inject(0) {|max, t| if t['id'].to_i > max then t['id'].to_i else max end }
      max_id + 1
    end

    def field_name
      self.class.instance_variable_get("@field_name")
    end
  end
end
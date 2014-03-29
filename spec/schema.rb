# Setup the db
ActiveRecord::Schema.define(:version => 1) do
  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "tags",       default: [], array: true
  end
end

class User < ActiveRecord::Base
  # many embedded tags
  embeds_many :tags

  # validation tags
  embedded :tags do
    embedded_fields :name, :color

    validates :name, uniqueness: true, presence: true
    validates :color, presence: true

    def as_json
      {
        id: id,
        name: name,
        color: color
      }
    end
  end
end

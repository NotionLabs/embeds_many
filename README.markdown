EmbedsMany
==============

EmbedsMany allows programmers to work with embedded records the same way as activerecord objects, with the power of PostgreSQL's hstore and array.

**NOTE**: EmbedsMany only works with Rails/ActiveRecord `4.0.4` or above. To use EmbedsMany, you must use PostgreSQL.

## Usage

### Installation

To use the gem, add following to your Gemfile:

``` ruby
gem 'embeds_many'
```

### Setup Database

You need a `hstor array` column to hold the embedded records.

When creating a new table, use following:

```ruby
  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "tags",       default: [], array: true
  end
```

When adding a column to existing table, use following:

```ruby
add_column :users, :tags, :hstore, array: true, default: []
```

### Setup Model

```
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
```

### Work with embedded tags

```ruby
# create new tag
@tag = user.tags.new(tag_params)
unless @tag.save
  render json: { success: false, message: @tag.errors.full_messages.join('. ') }
end

# update
@tag = user.tags.find(params['id'])

if @tag.update(tag_params)
  # do something
end

# destroy
@tag = user.tags.find(params['id'])

@tag.destroy
```

## Development



## License

Copyright (c) 2014 Notion Labs, released under the MIT license
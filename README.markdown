EmbedsMany
==============

[![Build Status](https://travis-ci.org/NotionLabs/embeds_many.svg)](https://travis-ci.org/NotionLabs/embeds_many)

EmbedsMany allows programmers to work with embedded records the same way as activerecord objects, with the power of PostgreSQL's hstore and array.

**NOTE**: EmbedsMany only works with Rails/ActiveRecord `4.0.4` or above. To use EmbedsMany, you must use PostgreSQL.

## Limitations and assumptions

- Embedded keys and values can only be simply text strings due to the restriction of [hstore](http://www.postgresql.org/docs/9.2/static/hstore.html).
- Embedded records should be of limited number, or they may cause performance problems.
- The `id` of embedded records may duplicate when race condition happens.

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

A simple usage is as follows:

```ruby
class User < ActiveRecord::Base
  # embedded tags
  embeds_many :tags
end
```

If you need validations on embedded records, you can provide an optional block:

```ruby
class User < ActiveRecord::Base
  # embedded tags
  embeds_many :tags do
    # add accessors
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

**Note**: There's no need to define a class for the embedded records, it's taken over automatically by `embeds_many`.

### Work with embedded records

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

Embedded record are automatically saved on parent save. But invalid embedded records are not auto saved.

``` ruby
# auto save on parent save
user = User.new(name: 'test')
user.tags.new(tag_params)

user.save

# auto save on parent update
@tag = user.tags.find(params['id'])
@tag.color = 'red'

user.update(name: 'bob')
```

## Development

All pull requests are welcome.

### Setup development environment

1. Run `bundle install`
2. Run `rake db:create` to create database
3. Run `rake spec` to run specs

### Development Guide

- Follow established and good convention
- Write code and specs
- Send pull request

## License

Copyright (c) 2014 Notion Labs, released under the MIT license
require "active_record"
require "active_model"

require "embeds_many/version"
require "embeds_many/base"
require "embeds_many/child"
require "embeds_many/child_collection"

ActiveRecord::Base.extend(EmbedsMany::Base)

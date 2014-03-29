require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :db do
  task :create_user do
    `createuser -s -r postgres`
  end

  task :create do
    `psql -c 'create database embeds_many_test;' -U postgres`
    `psql embeds_many_test -c 'create extension hstore;' -U postgres`
  end

  task :drop do
    `dropdb 'embeds_many_test'`
  end
end

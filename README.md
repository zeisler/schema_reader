# Schema Reader
[![Build Status](https://travis-ci.org/zeisler/SchemaReader.png?branch=master)](https://travis-ci.org/zeisler/SchemaReader)

Reads Rails Database schema.rb and creates a class from selected table with getters and setters.

This was created for unit testing Rails ActiveRecord. Instead of creating a mock that can
become out of date with real objects schema reader creates mocks form the true definition.

## Installation

Add this line to your application's Gemfile:

    gem 'schema_reader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install schema_reader

## Usage

    # db/schema.rb

    ActiveRecord::Schema.define(version: 20131226214224) do

      create_table "users", force: true do |t|
        t.string   "name"
        t.integer  "age"
        t.string   "email"
      end

      create_table "comments", force: true do |t|
          t.text    "comment"
          t.integer  "user_id"
          t.datetime "created_at"
          t.datetime "updated_at"
        end

    end

    # /spec/*
    class User
      include SchemaReader
      attr_schema table: 'users', file:  File.new('db/schema.rb', 'r')
    end

    user = User.new(name: 'Fred', age: 37, email: "fred@example.com")

    user.name
        => "Fred"
    user.name = "Jane"
    user.name
        => "Jane"

    user.update(age: 23)
    user.age
        => 23

    class Comment
      include SchemaReader
      attr_schema table: 'comments', file:  File.new('db/schema.rb', 'r')
    end

    # Based off field names ending with _id it will create an association

    comment = Comment.new(user: user)
    comment.user.name
         => "Jane"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
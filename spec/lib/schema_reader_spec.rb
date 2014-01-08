require 'rspec'
require_relative '../../lib/schema_reader'

describe SchemaReader do

  context 'read_schema' do

    before do
      class SchemaHash
        include SchemaReader
        attr_accessor *read_schema('users', File.new('schema.rb', 'r'))
      end
    end

    it 'returns attributes from schema file' do
      expect(SchemaHash.read_schema('users', File.new('schema.rb', 'r'))).to eq [:name, :age, :email, :created_at, :updated_at]
    end

    it 'will raise an exception if table does not exist' do
      -> {SchemaHash.read_schema('persons', File.new('schema.rb', 'r'))}.should raise_error('Table Name not Found!')
    end

  end

  describe 'attr_schema' do

    before do
      class User
        include SchemaReader
        attr_schema table: 'users',
                    file:  File.new('schema.rb', 'r')
      end
    end

    let(:user) {User.new}
    let(:attributes) { Hash.new(name: 'Fred', age: 37, email: "fred@example.com") }

    it 'will set getters and setters for schema attributes on object' do
      attributes.each_pair do |attribute, value|
        user.send("#{attribute}=", value)
        expect(user.send(attribute)).to eq value
      end
    end

    it 'will not respond to non-schema attributes' do
      expect(user.respond_to? :birth_date).to eq(false)
    end

    it 'update' do
      user.update(name: "Jane")
      expect(user.name).to eq('Jane')
    end

  end

  describe 'associations' do

    before do
      class Comment
        include SchemaReader
        attr_schema table: 'comments',
                    file:  File.new('schema.rb', 'r')
      end

      class User
        include SchemaReader
        attr_schema table: 'users',
                    file:  File.new('schema.rb', 'r')
      end
    end
    let(:comment) {Comment.new(user: User.new)}

    it 'will create associations of attributes ending with _id' do
      expect(comment.user.class).to eq User
    end

  end

end
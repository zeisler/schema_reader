require "schema_reader/version"

module SchemaReader
  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(options = {})
    update(options)
  end

  def update(options = {})
    options.each do |attribute, value|
      send("#{attribute}=", value)
    end
  end
  alias_method :update_attributes, :update

  module ClassMethods

    def attr_schema(options = {})
      table = options.fetch(:table)
      file = options.fetch(:file)
      self.send(:attr_accessor, *read_schema(table, file))
    end

    def read_schema(table_selected, path)
      tables = parse_for_tables(path)
      table = find_table(tables, table_selected)
      field_names = get_table_field_name(table)
      add_associations(field_names)
    end

    private

    def add_associations(field_names)
      association_fields = field_names.select {|field| field =~ /_id/}
      field_names += association_fields.map {|field| field.to_s.delete('_id').to_sym}
      field_names
    end

    def parse_for_tables(path)
      File.read(path).split(/^\s*create_/)[1..-1].map {|table_data| Table.parse table_data }
    end

    def find_table(tables, table_selected)
      table = tables.select do |table|
        table.name == table_selected
      end
      raise "Table Name not Found!" if table.first.nil?
      table.first
    end

    def get_table_field_name(table)
      table.attributes.map do |attribute|
        attribute.name.to_sym
      end
    end

  end

  class Attribute

    attr_reader :name, :type

    def initialize(type, name)
      @name, @type = name, type
    end

    def self.parse(attribute)
      match = attribute.match(/t\.(\w+)\s+"(\w+)"/)
      if match
        Attribute.new(*match.captures)
      end
    end

  end

  class Table

    attr_reader :attributes, :name

    def initialize(name, attributes)
      @name, @attributes = name, attributes
    end

    def self.parse(table_data)
      return unless name = table_data[/table "(.+)"/]
      name = $1
      atts = table_data.lines.to_a.select {|line| line =~ /t\.\w+/ }.map {|att| Attribute.parse att }
      Table.new(name, atts)
    end

  end

end
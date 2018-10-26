module RailsDrawIoDiagram
  class Model
    attr_accessor :model

    def initialize(model:)
      @model = model
      RailsDrawIoDiagram::ModelRegistry.add(self)
    end

    def class_name
      model.name
    end

    def table_name
      model.table_name
    end

    def fields
      @fields ||= model.column_names.map do |column_name|
        RailsDrawIoDiagram::Field.new(field_name: column_name, model: self)
      end
    end

    def field(field_name)
      fields.detect { |field| field.field_name == field_name }
    end

    def foreign_keys
      belongs_tos.map do |belongs_to|
        binding.pry
        # RailsDrawIoDiagram::ForeignKey.new(
        {
          from_field: field(belongs_to.foreign_key),
          to_field: RailsDrawIoDiagram::ModelRegistry.model(belongs_to.class_name).field('id')
        #)
        }
      end
    end

    private

    def belongs_tos
      model.reflect_on_all_associations(:belongs_to)
    end
  end
end

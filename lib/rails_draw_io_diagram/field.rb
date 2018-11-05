module RailsDrawIoDiagram
  class Field
    attr_accessor :id, :field_name, :model, :foreign_key

    def initialize(field_name:, model:)
      @id = RailsDrawIoDiagram::Sequence.next_id
      @field_name = field_name
      @model = model
    end

    def key_type
      return 'PK' if primary_key?
      return 'FK' if foreign_key?
      ''
    end

    def primary_key?
      field_name == model.model.primary_key
    end

    def foreign_key?
      model.foreign_key(field_name).present?
    end

  end
end

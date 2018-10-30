module RailsDrawIoDiagram
  class Field
    attr_accessor :id, :field_name, :model, :foreign_key

    def initialize(field_name:, model:, foreign_key:)
      @id = RailsDrawIoDiagram::Sequence.next_id
      @field_name = field_name
      @model = model
      @foreign_key = foreign_key
    end

    def key_type
      return 'PK' if primary_key?
      return 'FK' if foreign_key?
      return 'rk' if remote_key?
      ''
    end

    def primary_key?
      field_name == 'id'
    end

    def foreign_key?
      foreign_key
    end

    def remote_key?
      field_name =~ /^.*_id$/
    end

  end
end

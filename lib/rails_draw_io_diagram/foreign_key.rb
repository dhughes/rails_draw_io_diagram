module RailsDrawIoDiagram
  class ForeignKey
    attr_accessor :from_field, :to_field

    def initialize(from_field:, to_field:)
      @from_field = from_field
      @to_field = to_field
    end
  end
end

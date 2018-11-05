module RailsDrawIoDiagram
  class LayoutService
    attr_accessor :models

    def initialize(models: models)
      @models = models
    end

    def trim
      models.select do |model|
        model.foreign_keys.any?
      end
    end

  end
end

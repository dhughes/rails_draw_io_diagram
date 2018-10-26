module RailsDrawIoDiagram
  class ModelRegistry

    @@models = Set.new

    def self.add(model)
      @@models << model
    end

    def self.model(class_name)
      @@models.detect { |model| model.class_name == class_name }
    end

    def self.models
      @@models
    end

    def self.reset
      @@models = []
    end

  end
end

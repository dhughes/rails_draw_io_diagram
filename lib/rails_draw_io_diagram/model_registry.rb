module RailsDrawIoDiagram
  class ModelRegistry
    @@models = []

    def self.add(model)
      @@models << model
    end

    def self.model(class_name)
      binding.pry
      @@models.detect { |model| model.class_name == class_name }
    end
  end
end
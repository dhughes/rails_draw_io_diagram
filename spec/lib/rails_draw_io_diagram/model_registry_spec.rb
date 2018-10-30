RSpec.describe RailsDrawIoDiagram::ModelRegistry do
  it 'exists' do
    RailsDrawIoDiagram::ModelRegistry
  end

  it 'holds a registry of models' do
    RailsDrawIoDiagram::Model.new(model: Campaign)
    model = RailsDrawIoDiagram::Model.new(model: Partner)

    expect(RailsDrawIoDiagram::ModelRegistry.model('Partner')).to eq(model)
  end

  it 'has a set of models' do
    RailsDrawIoDiagram::Model.new(model: Campaign)
    RailsDrawIoDiagram::Model.new(model: Partner)

    expect(RailsDrawIoDiagram::ModelRegistry.models.size).to eq(2)
  end

end

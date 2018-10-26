RSpec.describe RailsDrawIoDiagram::ModelRegistry do
  it 'exists' do
    RailsDrawIoDiagram::ModelRegistry
  end

  it 'holds a registry of models' do
    RailsDrawIoDiagram::ModelRegistry.add(RailsDrawIoDiagram::Model.new(model: Campaign))
    model = RailsDrawIoDiagram::Model.new(model: Partner)
    RailsDrawIoDiagram::ModelRegistry.add(model)

    expect(RailsDrawIoDiagram::ModelRegistry.model('Partner')).to eq(model)
  end

end

RSpec.describe RailsDrawIoDiagram::Diagram do
  it 'adds models to the registry' do
    diagram = RailsDrawIoDiagram::Diagram.new(models: [Campaign, Partner, Vertical])

    expect(RailsDrawIoDiagram::ModelRegistry.models.size).to eq(3)
  end

  it 'creates xml for a lone model' do
    diagram = RailsDrawIoDiagram::Diagram.new(models: [Vertical])

    expect(diagram.database_xml).to eq(samples.single_table_diagram)
  end
end

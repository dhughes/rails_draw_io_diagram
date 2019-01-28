RSpec.describe RailsDrawIoDiagram::Diagram::Diagram do
  it 'adds models to the registry' do
    RailsDrawIoDiagram::Diagram::Diagram.new(models: [Campaign, Partner, Vertical])

    expect(RailsDrawIoDiagram::ModelRegistry.models.size).to eq(3)
  end

  it 'creates xml for a lone model' do
    diagram = RailsDrawIoDiagram::Diagram::Diagram.new(models: [Vertical])

    expect(diagram.database_xml).to be_present
    #expect(diagram.database_xml).to eq(samples.single_table_diagram)
  end

  it 'creates xml for multiple models' do
    diagram = RailsDrawIoDiagram::Diagram::Diagram.new(models: [Campaign, Partner, Vertical, PartnerAutomationSetting, RealEstateAgent, Listing])
    # TODO: this is so that I can easily copy the generated xml. it should be removed
    IO.popen('pbcopy', 'w') { |f| f << diagram.database_xml }

    expect(diagram.database_xml).to be_present
    #expect(diagram.database_xml).to eq(samples.multiple_table_diagram)
  end

  it 'calculate the minimum cell length' do
    diagram = RailsDrawIoDiagram::Diagram::Diagram.new(models: [Campaign, Partner, Vertical, PartnerAutomationSetting, RealEstateAgent, Listing])

    expect(diagram.minimum_cell_length).to eq(170)
  end

  it 'calculate the maximum cell length' do
    diagram = RailsDrawIoDiagram::Diagram::Diagram.new(models: [Campaign, Partner, Vertical, PartnerAutomationSetting, RealEstateAgent, Listing])

    expect(diagram.maximum_cell_length).to eq(350)
  end

  it 'calculates the size of a grid cell' do
    diagram = RailsDrawIoDiagram::Diagram::Diagram.new(models: [Campaign, Partner, Vertical, PartnerAutomationSetting, RealEstateAgent, Listing])

    expect(diagram.grid_cell_size).to eq(350)
  end

  it "calculates the width of a given model in a cell" do
    diagram = RailsDrawIoDiagram::Diagram::Diagram.new(models: [Campaign, Partner, Vertical, PartnerAutomationSetting, RealEstateAgent, Listing])

    expect(diagram.model_width(Campaign)).to eq((240+80)/350)
  end


end

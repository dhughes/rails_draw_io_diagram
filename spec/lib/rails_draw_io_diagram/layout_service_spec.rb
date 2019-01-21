RSpec.describe RailsDrawIoDiagram::LayoutService do
  it 'exists' do
    models = [Campaign, Partner].map { |model| RailsDrawIoDiagram::Model.new(model: model)}
    RailsDrawIoDiagram::LayoutService.new(models: models)
  end

  it 'trims leaves' do
    models = [Campaign, Partner].map { |model| RailsDrawIoDiagram::Model.new(model: model)}
    service = RailsDrawIoDiagram::LayoutService.new(models: models)

    expect(service.trim).to eq([models.first])
  end

  it 'can identify two models that only refer to each other'

  it 'can identify three models that only refer to each other'
end

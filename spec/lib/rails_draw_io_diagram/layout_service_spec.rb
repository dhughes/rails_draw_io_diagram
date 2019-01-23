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

# from https://arxiv.org/pdf/1807.09368.pdf
#
# Graph
#   models (aka vertexes)
#   foreign_keys (aka edges)
# place_nodes(graph, minimum_node_width, minimum_node_height)
#   In the PDF, the output from this method is the top left corner of each node. (Not sure how they're associated yet)
#   For ours, we may just modify the nodes directly.
#
#   determine the longest and shortest sides in the graph. (IE, count the number of rows+1 * the height of the row in pixels or 300 (I think), which is the default width.)
#
#   Assume each node in the graph (a model) has the same width and height.

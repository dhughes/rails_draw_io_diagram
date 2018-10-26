RSpec.describe RailsDrawIoDiagram::Field do
  it 'exists' do
    model = RailsDrawIoDiagram::Model.new(model: Campaign)
    RailsDrawIoDiagram::Field.new(field_name: 'example', model: model)
  end

  it 'gets a unique id' do
    RailsDrawIoDiagram::Sequence.reset
    model = RailsDrawIoDiagram::Model.new(model: Campaign)
    field1 = RailsDrawIoDiagram::Field.new(field_name: 'example1', model: model)
    field2 = RailsDrawIoDiagram::Field.new(field_name: 'example2', model: model)

    expect(field1.id).to eq(1)
    expect(field2.id).to eq(2)
  end

  it 'knows the model it belongs to' do
    model = RailsDrawIoDiagram::Model.new(model: Campaign)
    field = RailsDrawIoDiagram::Field.new(field_name: 'example1', model: model)

    expect(field.model).to eq(model)
  end

end

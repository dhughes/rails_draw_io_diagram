RSpec.describe RailsDrawIoDiagram::Model do
  it 'can tell us its table' do
    model = RailsDrawIoDiagram::Model.new(model: Campaign)

    expect(model.table_name).to eq('campaigns')
  end

  it 'can list its fields' do
    model = RailsDrawIoDiagram::Model.new(model: Partner)

    fields = model.fields

    expect(fields.map(&:field_name)).to eq(%w(id name code vertical_id))
  end

  it 'can get a specific field' do
    model = RailsDrawIoDiagram::Model.new(model: Partner)

    expect(model.field('vertical_id').field_name).to eq('vertical_id')
  end

  it 'associates fields with itself' do
    model = RailsDrawIoDiagram::Model.new(model: Partner)

    expect(model.field('vertical_id').model).to eq(model)
  end

  it 'can list foreign keys' do
    RailsDrawIoDiagram::Model.new(model: Partner)
    RailsDrawIoDiagram::Model.new(model: Vertical)
    model = RailsDrawIoDiagram::Model.new(model: Campaign)

    expect(model.foreign_keys.map(&:from_field).map(&:field_name)).to eq(%w(partner_id vertical_id))
    expect(model.foreign_keys.map(&:to_field).map(&:field_name)).to eq(%w(id id))
    expect(model.foreign_keys.map(&:to_field).map(&:model).map(&:class_name)).to eq(%w(Partner Vertical))
  end

  it 'can generate an xml fragment' do
    model = RailsDrawIoDiagram::Model.new(model: Vertical)

    expect(model.to_xml.to_xml).to eq(samples.single_table_fragment)
  end

end

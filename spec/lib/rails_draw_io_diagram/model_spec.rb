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

    expect(model.to_xml).to be_present
    # expect(model.to_xml.to_xml).to eq(samples.single_table_fragment)
  end

  context "when a model doesn't have any foreign keys" do
    it 'is a leaf' do
      model = RailsDrawIoDiagram::Model.new(model: Listing)

      expect(model.leaf?).to eq(true)
    end
  end

  context "when a model has a foreign key" do
    it 'is not a leaf' do
      RailsDrawIoDiagram::Model.new(model: Vertical)
      model = RailsDrawIoDiagram::Model.new(model: Campaign)

      expect(model.leaf?).to eq(false)
    end
  end

  it "knows about referencing associations" do
    model = RailsDrawIoDiagram::Model.new(model: Vertical)
    RailsDrawIoDiagram::Model.new(model: Campaign)
    RailsDrawIoDiagram::Model.new(model: Partner)

    expect(model.referenced_by.size).to eq(2)
  end

  it "knows how all of its incoming and outgoing foreign key associations" do
    RailsDrawIoDiagram::Model.new(model: Vertical)
    RailsDrawIoDiagram::Model.new(model: Campaign)
    model = RailsDrawIoDiagram::Model.new(model: Partner)

    expect(model.associations.size).to eq(3)
  end

  it 'knows its width' do
    model = RailsDrawIoDiagram::Model.new(model: Campaign)

    expect(model.width).to eq(RailsDrawIoDiagram::Model::MODEL_WIDTH)
  end

  it 'knows its height' do
    model = RailsDrawIoDiagram::Model.new(model: Campaign)

    # Campaign has 8 fields
    expect(model.height).to eq(270)
  end
end

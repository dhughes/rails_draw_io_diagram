RSpec.describe RailsDrawIoDiagram::Sequence do
  it 'exists' do
    RailsDrawIoDiagram::Sequence
  end

  it 'returns sequential ids' do
    expect(RailsDrawIoDiagram::Sequence.next_id).to eq(1)
    expect(RailsDrawIoDiagram::Sequence.next_id).to eq(2)
  end

  it 'can be reset' do
    RailsDrawIoDiagram::Sequence.next_id

    RailsDrawIoDiagram::Sequence.reset

    expect(RailsDrawIoDiagram::Sequence.next_id).to eq(1)
    expect(RailsDrawIoDiagram::Sequence.next_id).to eq(2)
  end

  it 'can create a root id' do
    expect(RailsDrawIoDiagram::Sequence.root_id).to eq(1)
    expect(RailsDrawIoDiagram::Sequence.root_id).to eq(1)
  end

  it 'can create a base parent id' do
    expect(RailsDrawIoDiagram::Sequence.base_parent_id).to eq(1)
    expect(RailsDrawIoDiagram::Sequence.base_parent_id).to eq(1)
  end

end

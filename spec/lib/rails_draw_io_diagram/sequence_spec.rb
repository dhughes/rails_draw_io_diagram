RSpec.describe RailsDrawIoDiagram::Sequence do
  it 'exists' do
    RailsDrawIoDiagram::Sequence
  end

  it 'returns sequential ids' do
    RailsDrawIoDiagram::Sequence.reset
    expect(RailsDrawIoDiagram::Sequence.next_id).to eq(1)
    expect(RailsDrawIoDiagram::Sequence.next_id).to eq(2)
  end

  it 'can be reset' do
    RailsDrawIoDiagram::Sequence.next_id

    RailsDrawIoDiagram::Sequence.reset

    expect(RailsDrawIoDiagram::Sequence.next_id).to eq(1)
    expect(RailsDrawIoDiagram::Sequence.next_id).to eq(2)
  end

end

require 'rails_helper'

describe PurgeInactiveWalls do
  let(:since) { 48.hours }
  let(:command) { described_class.new since }
  let(:wall) do
    instance_double("Wall", destroy: true)
  end
  let(:wall_class) do
    class_double("Wall")
      .as_stubbed_const(transfer_nested_constants: true)
  end

  before do
    allow(wall_class).to receive(:inactive_since)
      .with(since)
      .and_return([wall])
  end

  before do
    command.execute
  end

  it 'destroys all the walls inactive since "since"' do
    expect(wall).to have_received(:destroy)
  end
end

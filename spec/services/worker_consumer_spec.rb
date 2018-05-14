require 'rails_helper'

RSpec.describe RabbitQueue::WorkerConsumer do
  subject do
    described_class
  end

  it '.initialize' do
    worker = described_class.new('test')
    expect(worker).to be_instance_of RabbitQueue::WorkerConsumer
    expect(worker.queue.name).to eq 'test'
  end

  it '.ack' do
    worker = described_class.new('test')
    expect(RabbitQueue::Configurator.reader_channel).to receive(:acknowledge)
      .with('test', false)
    worker.ack('test')
  end
end

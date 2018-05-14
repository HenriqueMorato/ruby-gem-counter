require 'rails_helper'

RSpec.describe RabbitQueue::Configurator do
  subject do
    described_class
  end

  it '.reader_connection' do
    RabbitQueue::Configurator.reader_connection = nil
    fake_connection = double('Bunny')
    expect(fake_connection).to receive(:start)
    expect(Bunny).to receive(:new).with(any_args).and_return fake_connection
    RabbitQueue::Configurator.reader_connection
  end

  it '.writer_connection' do
    RabbitQueue::Configurator.writer_connection = nil
    fake_connection = double('Bunny')
    expect(fake_connection).to receive(:start)
    expect(Bunny).to receive(:new).with(any_args).and_return fake_connection
    RabbitQueue::Configurator.writer_connection
  end
end

require 'rails_helper'

RSpec.describe RabbitQueue::Configurator do
  subject do
    described_class
  end

  it '.connection' do
    RabbitQueue::Configurator.connection = nil
    fake_connection = double('Bunny')
    expect(fake_connection).to receive(:start)
    expect(Bunny).to receive(:new).with(any_args).and_return fake_connection
    RabbitQueue::Configurator.connection
  end
end

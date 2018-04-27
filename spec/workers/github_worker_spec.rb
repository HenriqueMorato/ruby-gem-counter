require 'rails_helper'
require 'github'

RSpec.describe GithubWorker do
  it '.work', :vcr do
    worker = subject

    expect(RabbitQueue::CreateGithubRepository).to receive(:perform)
      .with('2018-01-21 1')
    expect(worker).to receive(:ack!)
    worker.work '2018-01-21 1'
  end
end

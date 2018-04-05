require 'rails_helper'

RSpec.describe RabbitQueue::CreateGithubRepository do
  subject do
    described_class
  end

  it '.perform' do
    data = '2017-01-01 1'
    expect(GithubService::Repository).to receive(:do_request).with(data)
    subject.perform(data)
  end
end

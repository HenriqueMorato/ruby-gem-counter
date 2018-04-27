# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubService::Repository do
  subject do
    described_class
  end

  it '.repositories', :vcr do
    repos = subject.repositories(initial_date: '2008-01-12',
                                 final_date: '2008-01-13')

    expect(repos.count).to eq 2
  end

  it '.perform' do
    expect(GithubService::Repository).to receive(:do_request)
      .with('2018-01-01 1')

    subject.do_request('2018-01-01 1')
  end

  it '.do_request success', :vcr do
    repos = subject.do_request('2018-01-01 1')

    expect(repos.first.full_name).to eq 'davydovanton/kan'
    expect(repos.count).to eq 30
  end

  it '.do_request failed' do
    expect(GithubService::Repository).to receive(:enqueue_github_repo_job)
      .with('2008-01-21 1')
    expect(GithubService::Repository).to receive(:sleep)
      .with(10)
    subject.do_request('2008-01-21 1')
  end

  it '.number_of_pages', :vcr do
    expect(described_class.number_of_pages(date: '2018-01-01',
                                           page: 1)).to eq 12
  end

  it 'number_pages failed' do
    expect(GithubService::Repository).to receive(:sleep_request)
    subject.number_of_pages(date: '2008-01-01', page: 1)
  end
end

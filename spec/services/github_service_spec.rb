# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubService::Repository, :vcr do
  subject do
    described_class.repositories(1)
  end

  it 'should return repositories' do
    subject
    first_repo = GithubRepository.first

    expect(first_repo.class).to be GithubRepository
    expect(first_repo.full_name).to eq 'rails/rails'
    expect(first_repo.url).to eq 'https://api.github.com/repos/rails/rails'
  end

  it '.number_of_pages' do
    expect(described_class.number_of_pages).to eq 14_391
  end
end

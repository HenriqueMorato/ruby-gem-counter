require 'rails_helper'

RSpec.describe GithubRepository, type: :model do
  it '.parse_gems', :vcr do
    repo = create(:github_repository)

    result = repo.parse_gems

    expect(result.class).to be Array
    expect(result.count).to eq 14
  end
end

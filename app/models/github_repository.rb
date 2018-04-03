class GithubRepository < ApplicationRecord
  def parse_gems
    response = GithubService.gemfile_client(url).get
    return nil unless response.status == 200

    GemfileReader.new(response.body).execute
  end
end

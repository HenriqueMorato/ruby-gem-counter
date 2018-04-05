require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    # TODO: mover isso para uma fixture
    @body = {
      total_count: 1,
      items: [{
        full_name: 'jamesgolick/markaby',
        url: 'https://api.github.com/users/jamesgolick'
      }]
    }

    @fail_header = {
      'x-ratelimit-limit': 0,
      'x-ratelimit-reset': Time.now.to_i + 10
    }

    stub_request(:get, 'https://api.github.com/search/repositories?page=1&per_page=30&q=created:2008-01-01%20language:ruby')
      .with(headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => "token #{Rails.configuration.gemcounter['github_token']}",
              'User-Agent' => 'Faraday v0.14.0'
            })
      .to_return(status: 403, body: @body.to_json, headers: { 'x-ratelimit-limit' => '0', 'x-ratelimit-reset' => Time.now.to_i + 10, 'Content-Type' => 'application/json' }).then
      .to_return(status: 200, body: @body.to_json, headers: { 'x-ratelimit-limit' => '30', 'x-ratelimit-reset' => Time.now.to_i - 10, 'Content-Type' => 'application/json' })

    stub_request(:get, 'https://api.github.com/search/repositories?page=1&per_page=30&q=created:2008-01-21%20language:ruby')
      .with(headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => "token #{Rails.configuration.gemcounter['github_token']}",
              'User-Agent' => 'Faraday v0.14.0'
            })
      .to_return(status: 403, body: @body.to_json, headers: { 'x-ratelimit-limit' => '0', 'x-ratelimit-reset' => Time.now.to_i + 10, 'Content-Type' => 'application/json' }).then
      .to_return(status: 200, body: @body.to_json, headers: { 'x-ratelimit-limit' => '30', 'x-ratelimit-reset' => Time.now.to_i - 10, 'Content-Type' => 'application/json' })
  end
end

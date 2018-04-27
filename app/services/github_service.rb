require 'faraday'
require 'faraday_middleware'

require_relative 'repository'

module GithubService
  class << self
    def endpoint
      'https://api.github.com'
    end

    def repositories_uri
      "#{endpoint}/search/repositories"
    end

    def gemfile_uri(repository_url)
      "#{repository_url}/contents/Gemfile"
    end

    def repositories_client
      base_client(uri: repositories_uri)
    end

    def gemfile_client(repository_url)
      base_client(uri: gemfile_uri(repository_url),
                  headers: { 'Accept': 'application/vnd.github.VERSION.raw' })
    end

    def base_client(uri:, headers: nil)
      new_connection(uri: uri, headers: headers)
    end

    private

    def new_connection(uri:, headers: nil)
      Faraday.new(url: uri) do |faraday|
        faraday.use :instrumentation
        faraday.headers['Authorization'] = "token #{github_token}"

        headers&.each do |key, value|
          faraday.headers[key] = value
        end

        faraday.response :json, parser_options: { symbolize_names: true },
                                content_type: /\bjson$/
        faraday.adapter :net_http
      end
    end

    def github_token
      Rails.configuration.gemcounter['github_token']
    end
  end
end

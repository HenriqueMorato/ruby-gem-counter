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

    def repositories_client
      base_client(uri: repositories_uri)
    end

    def base_client(uri:)
      @base_client ||= new_connection(uri)
    end

    private

    def new_connection(uri)
      Faraday.new(url: uri) do |faraday|
        faraday.use :instrumentation
        faraday.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"

        faraday.response :json, parser_options: { symbolize_names: true },
                                content_type: /\bjson$/
        faraday.adapter :net_http
      end
    end
  end
end

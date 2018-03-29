module GithubService
  class Repository
    class << self
      def repositories(upto_number = number_of_pages)
        obj = []
        1.upto(upto_number) do |index|
          response = GithubService.repositories_client.get do |req|
            req.url("?q=language:ruby&page=#{index}")
          end
          obj += map_repositories(response.body) if response.status == 200
        end
        obj
      end

      def find_or_create(full_name, url)
        GithubRepository.find_or_create_by(full_name: full_name, url: url)
      end

      def map_repositories(array)
        array[:items].map do |item|
          find_or_create(item[:full_name], item[:url])
        end
      end

      def number_of_pages
        response = GithubService.repositories_client.get do |req|
          req.url('?q=language:ruby&per_page=100')
        end

        (response.body[:total_count].to_f / 100).ceil
      end
    end
  end
end

module GithubService
  class Repository
    class << self
      def repositories(initial_date: '2008-01-01', final_date: Time.zone.today)
        repo_job = []
        Date.parse(initial_date).upto(Date.parse(final_date)) do |date_index|
          1.upto(number_of_pages(date: date_index.to_s, page: 1)) do |index|
            Rails.logger.debug "Dia: #{date_index}, Page: #{index}"
            repo_job << enqueue_github_repo_job("#{date_index} #{index}")
          end
        end
        repo_job
      end

      def do_request(data)
        split_data = data.split
        response = call_github_service(date: split_data[0], page: split_data[1])
        return map_repositories(response.body) if response.status == 200
        enqueue_github_repo_job(data) if response.status != 200
        sleep_request(response)
      end

      def find_or_create(full_name, url)
        GithubRepository.find_or_create_by(full_name: full_name, url: url)
      end

      def map_repositories(array)
        array[:items].map do |item|
          find_or_create(item[:full_name], item[:url])
        end
      end

      def number_of_pages(date:, page:)
        response = call_github_service(date: date, page: page)
        return calculate_page_number(response.body) if response.status == 200
        sleep_request(response)
        number_of_pages(date: date, page: page)
      end

      private

      def calculate_page_number(body, repos_per_page = 30)
        (body[:total_count].to_f / repos_per_page).ceil
      end

      def call_github_service(date:, page:)
        response = GithubService.repositories_client.get do |req|
          req.url("?q=created:#{date}+language:ruby&page=#{page}&per_page=30")
        end
        Rails.logger.debug "Status #{response.status}"
        response
      end

      def sleep_request(response)
        return if response.headers['x-ratelimit-remaining'].to_i >= 1
        time = response.headers['x-ratelimit-reset'].to_i - Time.now.to_i
        Rails.logger.debug "Will sleep #{time} seconds"
        sleep time.seconds
      end

      def enqueue_github_repo_job(data)
        RabbitQueue::CreateGithubRepository.enqueue(data)
      end
    end
  end
end

module RabbitQueue
  class CreateGithubRepository
    class << self
      def enqueue(data)
        Producer.enqueue(data, 'repositories')
      end

      def perform(data)
        GithubService::Repository.do_request(data)
      end
    end
  end
end

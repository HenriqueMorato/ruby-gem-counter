require 'sneakers'

class GithubWorker
  include Sneakers::Worker
  from_queue 'repositories'

  def work(msg)
    RabbitQueue::CreateGithubRepository.perform(msg)
    ack!
  end
end

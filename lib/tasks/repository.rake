namespace :repository do
  desc 'Generate Jobs that crawl Github repositories by date'
  task generate_repositories_jobs: :environment do
    Rails.logger.debug "Starting Github crawl\n"
    Date.parse('2008-01-01').upto(Time.zone.today) do |date_index|
      Rails.logger.debug "Doing date: #{date_index}"
      1.upto(number_of_pages(date: date_index, page: 1)) do |index|
        Rails.logger.debug "Date #{date_index} has a page: #{index}"
        RabbitQueue::CreateGithubRepository.enqueue("#{date_index} #{index}")
      end
    end
  end

  desc 'Call rake to initialize worker'
  task initialize_workers: :environment do
    system('WORKERS=GithubWorker rake sneakers:run')
  end

  private

  def number_of_pages(date:, page:)
    GithubService::Repository.number_of_pages(date: date, page: page)
  end
end

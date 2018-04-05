# frozen_string_literal: true

require_relative 'config/application'
require 'sneakers/tasks'

Rails.application.load_tasks

namespace :worker do
  task run: :environment do
    p 'Beatiful worker starting...'

    create_repository = RabbitQueue::WorkerConsumer.new('repositories')

    loop do
      create_repository.subscribe do |delivery_info, _metadata, payload|
        RabbitQueue::CreateGithubRepository.perform(payload)
        create_repository.ack(delivery_info.delivery_tag)
      end
    end
  end
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner'
require 'vcr'
require 'bunny-mock'
require 'webmock/rspec'
require 'webmock'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f  }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include WorkerAdditions
  config.include QueuePublisher
  config.include Sneakers::Testing

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  VCR.configure do |c|
    c.ignore_localhost = true
    c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    c.hook_into :webmock
    c.configure_rspec_metadata!
    c.filter_sensitive_data('<TOKEN>') { ENV['GITHUB_TOKEN'] }
  end

  config.before(:each) do |test|
    RabbitQueue::Configurator.connection = BunnyMock.new.start
    Sneakers::Testing.clear_all
    WebMock.disable_net_connect!(allow_localhost: true,
                                 allow: 'api.travis-ci.org')
  end

  config.around(:each) do |ex|
    if ex.metadata.key?(:vcr)
      ex.run
    else
      VCR.turned_off { ex.run }
    end
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

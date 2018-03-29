require 'simplecov'

SimpleCov.configure do
  add_group 'Services', 'app/services'
  add_filter 'application_cable'
  add_filter 'application_controller.rb'
  add_filter 'application_job.rb'
  add_filter 'application_mailer.rb'
end

SimpleCov.start 'rails'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

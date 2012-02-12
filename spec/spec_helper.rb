require 'simplecov'
SimpleCov.start 'rails'

require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # Configure Rails Envirnonment
  ENV["RAILS_ENV"] = "test"

  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
  require "rails/test_help"
  require "rspec/rails"

  ActionMailer::Base.delivery_method = :test
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.default_url_options[:host] = "test.com"

  Rails.backtrace_cleaner.remove_silencers!

  # Configure capybara for integration testing
  require "capybara/rails"
  require "capybara/rspec"
  Capybara.default_driver   = :rack_test
  Capybara.default_selector = :css

  RSpec.configure do |config|
    # Remove this line if you don't want RSpec's should and should_not
    # methods or matchers
    require 'rspec/expectations'
    config.include RSpec::Matchers
    config.color_enabled = true

    # == Mock Framework
    config.mock_with :rspec
  end
  require 'factory_girl'
  require 'fakeweb'

#  load(File.dirname(__FILE__) + '/schema.rb')

end

Spork.each_run do

  FactoryGirl.find_definitions

  # Load support files
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

  # Setup some test PermissionMap
  module ActsPermissive::PermissionMap
    SEE = 0
    READ = 1
    WRITE = 2
    ADMIN = 3
    OWNER = 4
  end

end

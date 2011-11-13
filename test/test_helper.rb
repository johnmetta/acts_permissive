# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

load(File.dirname(__FILE__) + '/schema.rb')

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require File.dirname(__FILE__) + '/../lib/generators/templates/membership.rb'
require File.dirname(__FILE__) + '/../lib/generators/templates/membership_container.rb'
require File.dirname(__FILE__) + '/../lib/generators/templates/circle.rb'

require 'shoulda'
require 'factory_girl'
FactoryGirl.find_definitions

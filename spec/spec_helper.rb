require 'simplecov'

SimpleCov.start do
  minimum_coverage(100)
end

require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

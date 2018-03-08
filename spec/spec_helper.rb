require 'simplecov'

SimpleCov.start do
  minimum_coverage(100)
end

require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def fixture(file)
  File.read(fixture_path(file))
end

def fixture_path(file)
  File.join(File.expand_path('../fixtures', __FILE__), file)
end

require 'pstore'
require File.expand_path('../lib/snakes_api', __FILE__)

SnakesAPI::App.opts[:db] = PStore.new('my_database.pstore')
SnakesAPI::App.opts[:generate_game_id] = SnakesAPI::GenerateID
SnakesAPI::App.opts[:generate_client_id] = SnakesAPI::GenerateID

run SnakesAPI::App.app

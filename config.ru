require 'pstore'
require File.expand_path('../lib/app', __FILE__)
App.opts[:db] = PStore.new('my_database.pstore')
run App.app

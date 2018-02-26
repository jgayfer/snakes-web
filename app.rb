require 'snakes'
require 'roda'

class App < Roda
  route do |r|
    r.root do
      'test'
    end
  end
end

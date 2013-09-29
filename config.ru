require './chsys-mon.rb'

set :run, false
set :environment, :production

run Sinatra::Application

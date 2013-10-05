require 'sinatra/base'
require 'mongoid'

configure :development do
  enable :logging
  set :clean_trace, true
  set :logger_level, :debug
  set :database, "sqlite3:///db/chsys-mon.db"

  set :views, Proc.new { File.join(settings.root, '/app/views/')}
  Mongoid.load!(File.join(settings.root, '/config/mongoid.yml'))
end

configure :production do
  enable :logging
  set :clean_trace, true
  set :logger_level, :info
  set :database, "sqlite3:///db/chsys-mon-production.db"

  set :views, Proc.new { File.join(settings.root, '/app/views/')}
  Mongoid.load!(File.join(settings.root, '/config/mongoid.yml'))
end

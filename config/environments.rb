require File.expand_path(File.dirname(__FILE__) + "/../app/helpers/MonitSettings.rb")

require 'sinatra/base'
require 'mongoid'

@@monit = MonitSettings.new

configure :development do
  enable :logging
  set :clean_trace, true
  set :logger_level, :debug
  set :database, "sqlite3:///db/chsys-mon.db"

  set :views, Proc.new { File.join(settings.root, '/app/views/')}
  Mongoid.load!(File.expand_path(File.dirname(__FILE__) + '/mongoid.yml'))
end

configure :production do
  enable :logging
  set :clean_trace, true
  set :logger_level, :info
  set :database, "sqlite3:///db/chsys-mon-production.db"

  set :views, Proc.new { File.join(settings.root, '/app/views/')}
  Mongoid.load!(File.expand_path(File.dirname(__FILE__) + '/mongoid.yml'))
end

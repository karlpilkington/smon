configure :production, :development do
  enable :logging
  set :logger_level, :debug
  set :database, "sqlite3:///db/chsys-mon.db"
  set :views, Proc.new { File.join(root, '/app/views/')}
end

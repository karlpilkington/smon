require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require "sinatra/activerecord"
require 'sinatra/logger'

require 'active_support/core_ext'
require 'json'

require './config/environments.rb'
require './app/model/machine.rb'
require './app/helpers/helpers.rb'

get '/' do
  logger.info("Machine: #{Machine.first.machine_id}")
  @machines = Machine.all()
  erb :index
end

get '/machines/:id' do
  @mach= Machine.find(params[:id])
  erb :show_mach
end

get '/collector' do
  ""
end

post '/collector' do
  protected!
  logger.info("Path: #{request.path_info}, Request: #{request.request_method}, Content Length: #{request.content_length}")
  json = Hash.from_xml(request.env["rack.input"].read).to_json
  logger.info("-------------\n #{json}")
  parsed_json = ActiveSupport::JSON.decode(json)

  #
  # If machine is already in DB just fetch it and update values in it.
  ###
  if not Machine.exists?(:machine_id => parsed_json['monit']['id'])
    @machine = Machine.new()
    @machine.machine_id = parsed_json['monit']['id']
  else
    @machine = Machine.find_by(:machine_id => parsed_json['monit']['id'])
  end

  @machine.json = json
  @machine.version = parsed_json['monit']['platform']['version']
  @machine.save!

  content_type 'text/plain'
  status 200
  " "
end

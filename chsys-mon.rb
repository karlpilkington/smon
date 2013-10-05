require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
#require "sinatra/activerecord"
require 'sinatra/logger'

require 'active_support/core_ext'
require 'json'

require 'mongoid'

require './config/environments.rb'
require './app/model/machine.rb'
require './app/helpers/helpers.rb'

get '/' do
  logger.info("Machine: #{Machine.first.machine_id}")
  @machines = Machine.all().to_a
  erb :index
end

get '/machines/:id' do
  @mach= Machine.where(machine_id: params[:id]).first
  erb :show_mach
end

post '/collector' do
  protected!
  logger.info("Path: #{request.path_info}, Request: #{request.request_method}, Content Length: #{request.content_length}")
  json = Hash.from_xml(request.env["rack.input"].read).to_json
  logger.info("-------------\n #{json}")
  parsed_json = ActiveSupport::JSON.decode(json)

  #
  # If machine is already in MONGODB just fetch it and update values in it.
  ###
  if not Machine.where(machine_id: parsed_json['monit']['id']).exists?
    @machine = Machine.new()
    @machine.machine_id = parsed_json['monit']['id']
  else
    logger.info("Got machine WTF ?")
    @machine = Machine.where(machine_id: parsed_json['monit']['id']).first
  end

  @machine.monit_json = json
  @machine.version = parsed_json['monit']['platform']['version']
  @machine.save

  content_type 'text/plain'
  status 200
end

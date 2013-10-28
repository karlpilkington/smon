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
  @machines = Machine.all().to_a
  erb :index
end

get '/machines/:id' do
  @mach= Machine.where('monit.id' =>  params[:id]).first
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
  if not Machine.where('monit.id' => parsed_json['monit']['id']).exists?
    @machine = Machine.new()
  else
    @machine = Machine.where('monit.id' => parsed_json['monit']['id']).first
  end

  @machine.health_check_count = @@monit.HealthCheckCount
  @machine.health_check_status = "Running"
  @machine.monit = parsed_json['monit']
  @machine.save

  content_type 'text/plain'
  status 200
end

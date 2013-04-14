require 'sinatra'
require 'uri'
require 'rest-client'
require 'json'

module Mater
  class Web < Sinatra::Base

    configure do
      enable :logging
    end

    before do
    end

    get '/render/' do
      #erb :index, :locals => { :device => 'Home' }
    end

    get '/health' do
      content_type :json
      {'status' => 'ok'}.to_json
    end
  end
end


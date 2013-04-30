require 'sinatra'
require 'rest-client'
require 'time'
require 'json'

module Mater
  class Web < Sinatra::Base

    configure do
      enable :logging
    end

    before do
      content_type :json
    end

    if ENV['MATER_AUTH']
      use Rack::Auth::Basic, "Restricted Area" do |username, password|
          [username, password] == ENV['MATER_AUTH'].split(':')
      end
    end

    get '/render/?' do
      data = JSON.parse(RestClient.get("#{ENV['GRAPHITE_URL']}#{request.env['REQUEST_URI']}"))
      data.each do |target|
        target['title'] = target['target']
        target.delete('target')
        datapoints = []
        target['datapoints'].each do |datapoint|
          time = Time.at(datapoint[1]).strftime("%H:%M")
          datapoints << {
            "title" => time,
            "value" => datapoint[0].to_i
          }
        end
        target['datapoints'] = datapoints
      end
      result = {
        'graph' => {
          'type' => 'line',
          'title' => params['title'],
          'datasequences' => data
        }
      }
      200
      result.to_json
    end

    get '/health' do
      200
      {'status' => 'ok'}.to_json
    end
  end
end


require 'sinatra'
require 'uri'
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

    get '/render/' do
      data = JSON.parse(RestClient.get("#{ENV['GRAPHITE_URL']}#{request.env['REQUEST_URI']}"))
      data.each do |target|
        target['title'] = target['target']
        target.delete('target')
        datapoints = []
        target['datapoints'].each do |datapoint|
          time = Time.at(datapoint[1]).to_time.to_s.split[1].gsub(/\:\d{2}$/, '')
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


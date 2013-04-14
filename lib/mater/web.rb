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
      content_type :json
    end

    get '/render/' do
      data = JSON.parse(RestClient.get("#{ENV['GRAPHITE_URL']}#{request.env['REQUEST_URI']}"))
      data.each do |target|
        target['title'] = target['target']
        target.delete('target')
        datapoints = []
        target['datapoints'].each do |datapoint|
          datapoints << {
            "title" => datapoint[1],
            "value" => datapoint[0]
          }
        end
        target['datapoints'] = datapoints
      end
      result = {
        'graph' => {
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


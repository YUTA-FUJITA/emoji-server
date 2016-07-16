
require 'sinatra'
require 'sinatra/base'
require 'open-uri'
require 'securerandom'
require 'pathname'
require 'json'

class App < Sinatra::Base
  DIR = "tmp" # heroku is writeable ./tmp or ./log

  get '/' do
    erb :index
  end

  post '/' do
    @error = "error get emoji.list."
    token = params[:token]
    unless token.nil? or token.empty?
      name = SecureRandom.uuid
      open(File.join(DIR, name), 'w') do |output|
        url = 'https://slack.com/api/emoji.list?token=' + token
        json = open(url).read
        unless json.nil? or json.empty?
          parsed = JSON.parse(json)
          if parsed["ok"]
            output << json
            @url = request.url + "#{DIR}/#{name}"
            @error = ""
          end
        end
      end
    end
    erb :index
  end

  get '/tmp/*' do |name|
    send_file File.join(DIR, name)
  end
end

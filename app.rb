
require 'sinatra'
require 'sinatra/base'
require 'open-uri'
require 'securerandom'
require 'pathname'

class App < Sinatra::Base
  DIR = "tmp" # heroku is writeable ./tmp or ./log

  get '/' do
    erb :index
  end

  post '/' do
    token = params[:token]
    unless token.nil? or token.empty?
      name = SecureRandom.uuid
      open(File.join(DIR, name), 'w') do |output|
        url = 'https://slack.com/api/emoji.list?token=' + token
        output << open(url).read
      end
      @url = request.url + "#{DIR}/#{name}"
    end
    erb :index
  end

  get '/tmp/*' do |name|
    send_file File.join(DIR, name)
  end
end

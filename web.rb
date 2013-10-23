require 'sinatra'
require 'json'
require 'open-uri'

post '/:room' do
  content_type :text
  travis = JSON.parse(request.body.read)
  repo = travis['payload']['repository']
  status = travis['payload']['status_message']
  compare = travis['payload']['compare_url']
  open("http://lingr.com/api/room/say?#{params[:room]}&bot_id=travis_ci&text=#{repo['owner_name']}/#{repo['name']} #{status}\n#{compare}").read
end

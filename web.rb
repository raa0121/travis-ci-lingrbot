require 'sinatra'
require 'json'
require 'open-uri'

post '/:room' do
  content_type :text
  travis = JSON.parse(request.body.read)
  repo = travis['payload']['repository']
  status = travis['payload']['status_message']
  compare = travis['payload']['compare_url']
  open("http://lingr.com/api/room/say?room=#{params[:room]}&bot=travis_ci&text=[#{repo['owner_name']}/#{repo['name']}]#{status}\n#{compare}&bot_verifier=255c91a32fc7e70b3421129ad0251df6c2c897d4").read
end

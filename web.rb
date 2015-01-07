require 'sinatra'
require 'json'
require 'open-uri'
require 'cgi'

get '/' do
  content_type :text
  "travis-ciのnotificationをLingrに通知するためのBotです。"
end

post '/' do
  ""
end

get '/:room' do
  content_type :text
  "http://lingr.com/room/#{params[:room]} 用のエンドポイントです。\nhttp://lingr.com/bot/travis_ciを部屋に追加してから、.travis.ymlのnotificationのWebHookのurlsに入れると動きます。"
end

post '/:room' do
  content_type :text
  travis = JSON.parse(params[:payload])
  repo = travis['repository']
  status = travis['status_message']
  compare = travis['compare_url']
  commit = travis['message']
  text = "[#{repo['owner_name']}/#{repo['name']}]#{status}:#{commit}\n#{compare}\nhttps://travis-ci.org/#{repo['owner_name']}/#{repo['name']}/builds"
  open("http://lingr.com/api/room/say?room=#{params[:room]}&bot=travis_ci&text=#{text}&bot_verifier=255c91a32fc7e70b3421129ad0251df6c2c897d4").read
end

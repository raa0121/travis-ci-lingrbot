express = require("express")
http = require("http")

app = express()

app.get "/:room(\\w+$)", (req, res) ->
  res.send "http://lingr.com/room/#{req.params.room} 用のエンドポイントです。\nhttp://lingr.com/bot/travis_ciを部屋に追加してから、.travis.ymlのnotificationのWebHookのurlsに入れると動きます。"

app.post '/:room(\\w+$)', (req, res) ->
  travis = JSON.parse(req.params.payload)
  repo = travis['repository']
  status = travis['status_message']
  compare = travis['compare_url']
  commit = travis['message']
  build = travis['build_url']
  text = encodeURIComponent("[#{repo['owner_name']}/#{repo['name']}]#{status}:#{commit}\n#{compare}\n#{build}")
  http.get("http://lingr.com/api/room/say?room=#{req.params.room}&bot=travis_ci&text=#{text}&bot_verifier=255c91a32fc7e70b3421129ad0251df6c2c897d4")

app.listen(process.env.PORT)

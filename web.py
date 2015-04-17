# -*- coding: utf-8 -*-
from flask import (Flask, request)
import os
import sys
import json
import urllib.parse
import urllib.request

sys.stdout.flush()

app = Flask(__name__)

@app.route('/<room>', methods=['GET', 'POST'])
def room(room=''):
    if request.method == 'GET':
        return "http://lingr.com/room/{0} 用のエンドポイントです。\nhttp://lingr.com/bot/travis_ciを部屋に追加してから、.travis.ymlのnotificationのWebHookのurlsに入れると動きます。".format(room)
    else:
        values = request.form.values()
        for v in values :
            travis = json.loads(v)
            repo = travis['repository']
            status = travis['status_message']
            compare = travis['compare_url']
            commit = travis['message']
            build = travis['build_url']
            text = urllib.parse.quote_plus("[{0}/{1}]{2}:{3}\n{4}\n{5}".format(repo['owner_name'], repo['name'], status, commit, compare, build), encoding="utf-8")
            response = urllib.request.urlopen("http://lingr.com/api/room/say?room={0}&bot=travis_ci&text={1}&bot_verifier=255c91a32fc7e70b3421129ad0251df6c2c897d4".format(room, text))
            html = response.read()
        return ''


if __name__ == '__main__':
    app.run(debug = True, port = int(os.getenv('PORT') or 10000))


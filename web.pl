use Mojolicious::Lite;
use URI::Escape;
use LWP::Simple;
use JSON::XS;

get '/:room' => sub {
  my $self = shift;
  my $room = $self->param('room');
  $self->render(text => "http://lingr.com/room/$room 用のエンドポイントです。\nhttp://lingr.com/bot/travis_ciを部屋に追加してから、.travis.ymlのnotificationのWebHookのurlsに入れると動きます。");
};

post '/:room' => sub {
  my $self = shift;
  my $room = $self->param('room');
  my $payload = $self->param('payload');
  my $travis = decode_json($payload);
  my $repo = $travis->{repository};
  my $status = $travis->{status_message};
  my $compare = $travis->{compare_url};
  my $commit = $travis->{message};
  my $build = $travis->{build_url};
  my $text = uri_escape_utf8("[$repo->{'owner_name'}/$repo->{'name'}]$status:$commit\n$compare\n$build");
  my $html = get("http://lingr.com/api/room/say?room=$room&bot=travis_ci&text=$text&bot_verifier=255c91a32fc7e70b3421129ad0251df6c2c897d4")
};

app->start;

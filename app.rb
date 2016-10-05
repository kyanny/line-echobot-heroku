require 'sinatra'   # gem 'sinatra'
require 'line/bot'  # gem 'line-bot-api'
require 'httpclient'

class MyClient < HTTPClient
  def get(url, header={})
    get_content(url, nil, header)
  end

  def post(url, payload, header={})
    post_content(url, payload, header)
  end
end

post '/callback' do
  client = Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    # config.httpclient = HTTPProxyClient.new
    # config.httpclient = MyRestClient.new
    config.httpclient = MyClient.new(ENV["FIXIE_URL"])
    proxy_uri = URI(ENV["FIXIE_URL"])
    config.httpclient.set_proxy_auth(proxy_uri.user, proxy_uri.password)
  }

  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  p events

  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        res = client.reply_message(event['replyToken'], message)
        p res
        p res.body
      end
    end
  }

  "OK"
end

require 'sinatra'   # gem 'sinatra'
require 'line/bot'  # gem 'line-bot-api'

class HTTPProxyClient

  def http(uri)
    require 'uri'
    proxy_uri = URI(ENV["FIXIE_URL"])
    p proxy_uri
    http = Net::HTTP.new(uri.host, uri.port, proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
    if uri.scheme == "https"
      http.use_ssl = true
    end

    http
  end

  def get(url, header = {})
    uri = URI(url)
    http(uri).get(uri.request_uri, header)
  end

  def post(url, payload, header = {})
    uri = URI(url)
    http(uri).post(uri.request_uri, payload, header)
  end

end

before do
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      config.httpclient = HTTPProxyClient.new
    }
    p ['@client = ', @client,
       @client.httpclient.instance_variable_get('@proxy_host'),
       @client.httpclient.instance_variable_get('@proxy_port'),
       @client.httpclient.instance_variable_get('@proxy_user'),
       @client.httpclient.instance_variable_get('@proxy_pass'),
      ]

    @client
  end
end

post '/callback' do
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
        p client.httpclient.instance_eval('@proxy_pass')
      end
    end
  }

  "OK"
end

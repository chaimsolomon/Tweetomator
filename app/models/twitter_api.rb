require 'twitter'

class TwitterApi
  def initialize
    configkeys = YAML.load_file("#{Rails.root.to_s}/config/keys.yml")['twitter']
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = configkeys['consumer_key']
      config.consumer_secret     = configkeys['consumer_secret']
      config.access_token        = configkeys['access_token']
      config.access_token_secret = configkeys['access_token_secret']
    end
  end

  def search(term)
    @client.search(term, result_type: "recent").take(10)
  end
end

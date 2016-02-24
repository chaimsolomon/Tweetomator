require 'spec_helper'
require 'webmock/rspec'
describe 'Twitter Api search for tomato' do

  context 'calls out to twitter and' do
    let(:twitter_api) {TwitterApi.new}

    MOCK_BODY = File.read('spec/twitter_search_result_body.txt')
    before(:example) {
      stub_request(:get, "https://api.twitter.com/1.1/search/tweets.json?count=100&q=tomato&result_type=recent").
               with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                                 'User-Agent'=>'TwitterRubyGem/5.16.0'}).
               to_return(:status => 200, :body => MOCK_BODY, :headers => {})
    }

    it 'should return 10 responses' do
        response = twitter_api.search('tomato')
        response.length.should == 10
    end


    it 'should return tweets' do
        response = twitter_api.search('tomato')
        response.first.should be_a(Twitter::Tweet)
    end

    it 'should return tweet with a particular text' do
        response = twitter_api.search('tomato')
        response.first.text.should == 'TEST TWEET'
    end
  end

  context 'initialization' do
    it 'should read the keys file, parse it and set the configuration' do
      expect(YAML).to receive(:load_file).with("#{Rails.root.to_s}/config/keys.yml").once.and_return({"twitter"=>{"consumer_key"=>"ckey", "consumer_secret"=>"csec", "access_token"=>"at", "access_token_secret"=>"ats"}})
      TwitterApi.new
    end

    it 'should set the configuration variables' do
      expect(YAML).to receive(:load_file).with("#{Rails.root.to_s}/config/keys.yml").once.and_return({"twitter"=>{"consumer_key"=>"ckey", "consumer_secret"=>"csec", "access_token"=>"at", "access_token_secret"=>"ats"}})
      result = TwitterApi.new
      client = result.instance_variable_get(:@client)
      client.consumer_key.should == 'ckey'
      client.consumer_secret.should == 'csec'
      client.access_token.should == 'at'
      client.access_token_secret.should == 'ats'
    end
  end

  context 'search' do
    let(:twitter_api) {TwitterApi.new}

    it 'should use the provided search term' do
      client = twitter_api.instance_variable_get(:@client)
      expect(client).to receive(:search).with('TERM', result_type: "recent").and_return([*20])
      twitter_api.search('TERM')
    end

    it 'should return 10 results' do
      client = twitter_api.instance_variable_get(:@client)
      expect(client).to receive(:search).and_return([*1..20])
      twitter_api.search('TERM').should == [*1..10]
    end
  end

end

require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'hnS5WXiGcemc8m0ihD0q8SwUn'
  config.consumer_secret = 'Afw4F6Pb14dfLNyuSywL8r4Z7GNPQoKyiVU585wJBWkxMOOfzO'
  config.access_token = '4273108759-gXDejwNP601V9mb7TeDFC7rXsOacxJmOzeHCTNO'
  config.access_token_secret = 'aw7206LKiCgsi4Xwyq8OrUI3h1zRpTM5WtgOuV3wKxbHn'
end

search_term = URI::encode('from:MYOB')

SCHEDULER.every '5m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
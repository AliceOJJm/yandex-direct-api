require 'net/http'
require 'net/https'
require 'json'
require 'yaml'
require 'uri'

class YandexDirect::Client
  attr_reader :ad_groups, :ads, :bids, :campaigns, :dictionaries, :keywords, :sitelinks, :vcards

  def initialize(configuration)
    @configuration = configuration
    @ad_groups = YandexDirect::AdGroup.new(self)
    @ads = YandexDirect::Add.new(self)
    @bids = YandexDirect::Bid.new(self)
    @campaigns = YandexDirect::Campaign.new(self)
    @dictionaries = YandexDirect::Dictionaries.new(self)
    @keywords = YandexDirect::Keyword.new(self)
    @sitelinks = YandexDirect::Sitelink.new(self)
    @vcards = YandexDirect::VCard.new(self)
  end

  def request *args
    YandexDirect.request(*args, config: @configuration)
  end
end

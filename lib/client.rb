require 'net/http'
require 'net/https'
require 'json'
require 'yaml'
require 'uri'

class YandexDirect::Client
  attr_reader :ad_groups, :ads, :bids, :campaigns, :dictionaries, :keywords, :sitelinks, :vcards

  def initialize(@configuration)
    ad_groups = AdGroup.new(self)
    ads = Add.new(self)
    bids = Bid.new(self)
    campaigns = Campaign.new(self)
    dictionaries = Dictionarie.new(self)
    keywords = Keyword.new(self)
    sitelinks = Sitelink.new(self)
    vcards = VCard.new(self)
  end

  def request *args
    YandexDirect.request(args, config: @configuration)
  end
end

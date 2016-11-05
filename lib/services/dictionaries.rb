class YandexDirect::Dictionaries
  SERVICE = 'dictionaries'

  def initialize(client)
    @client = client
  end

  def get_regions
    @client.request(SERVICE, 'get', {"DictionaryNames": ["GeoRegions"]})["GeoRegions"]
  end
end

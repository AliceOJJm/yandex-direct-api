class YandexDirect::Sitelink
  SERVICE = 'sitelinks'

  def initialize(client)
    @client = client
  end
  
  def add_set(params)
    sitelinks = params.map do |link|
      hash = {"Title": link[:title], "Href": link[:href]}
      hash["Description"] = link[:description] if link[:description].present?
      hash
    end
    @client.request(SERVICE, 'add', {"SitelinksSets": [{"Sitelinks": sitelinks}]})["AddResults"].first["Id"]
  end

  def get(ids)
    @client.request(SERVICE, 'get', {"SelectionCriteria": {"Ids": ids}, "FieldNames": ["Id", "Sitelinks"]})["SitelinksSets"] || []
  end

  def delete(ids)
    @client.request(SERVICE, 'delete', {"SelectionCriteria": {"Ids": ids}})
  end
end

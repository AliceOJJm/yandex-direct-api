class YandexDirect::VCard
  SERVICE = 'vcards'

  def initialize(@client)
  end

  def get(ids = nil)
    params = {"FieldNames": ["Id", "Country", "City", "Street", "House", "Building", "Apartment", "CompanyName", "ExtraMessage", "ContactPerson", "ContactEmail", "MetroStationId", "CampaignId", "Ogrn", "WorkTime", "InstantMessenger", "Phone", "PointOnMap"]}
    params["SelectionCriteria"] = {"Ids": ids} if ids.present?
    @client.request(SERVICE, 'get', params)["VCards"] || []
  end

  def add(params)
    vcard = { "CampaignId": params[:campaign_id],
              "Country": params[:country],
              "City": params[:city],
              "CompanyName": params[:company_name],
              "WorkTime": params[:work_time],
              "Phone": {
                "CountryCode": params[:country_code],
                "CityCode": params[:city_code],
                "PhoneNumber": params[:phone_number]
              }
            }
    %w(Street House Building Apartment ExtraMessage Ogrn ContactEmail MetroStationId ContactPerson).each do |key| 
      vcard[key] = params[key.underscore.to_sym] if params[key.underscore.to_sym].present?
    end
    vcard["InstantMessenger"] = {"MessengerClient": params[:messenger_client], "MessengerLogin": params[:messenger_login]} if params[:messenger_client].present? && params[:messenger_login].present?
    vcard[:Phone]["Extension"] = params[:phone_extension] if params[:phone_extension].present?
    @client.request(SERVICE, 'add', {"VCards": [vcard]})["AddResults"].first["Id"]
  end

  def delete(ids)
    @client.request(SERVICE, 'delete', {"SelectionCriteria": {"Ids": ids}})
  end
end

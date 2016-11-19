class YandexDirect::Campaign
  SERVICE = 'campaigns'

  def initialize(client)
    @client = client
  end

  def list
    @client.request(SERVICE, 'get', { 
      "SelectionCriteria": {
        "Types": ["TEXT_CAMPAIGN"], 
        "States": ["OFF", "ON"], 
        "Statuses": ["ACCEPTED", "DRAFT", "MODERATION"]
      },
      "FieldNames": ['Id', 'Name', 'State', 'Status', 'TimeTargeting', 'NegativeKeywords', 'ClientInfo', 'Type'],
      "TextCampaignFieldNames": ["BiddingStrategy"]
    })["Campaigns"].to_a
  end

  def add(params)
    if params.kind_of?(Array)
      batch_add(params)
    else
      params.type ||= "TEXT_CAMPAIGN"
      special_parameters = params.text_campaign_parameters if params.type == "TEXT_CAMPAIGN"
      @client.request(SERVICE, 'add', {"Campaigns": [params.parameters(special_parameters)]})["AddResults"].first
    end
  end

  def update(params)
    if params.kind_of?(Array)
      batch_update(params)
    else
      params.type ||= "TEXT_CAMPAIGN"
      special_parameters = params.text_campaign_parameters if params.type == "TEXT_CAMPAIGN"
      params.id = @client.request(SERVICE, 'update', {"Campaigns": [params.parameters(special_parameters)]})["UpdateResults"].first["Id"]
      params
    end
  end

  def parameters(campaign_type)
    hash = {"Name": @name,
            "ClientInfo": @owner_name,
            "Notification": {  
              "EmailSettings": {
                "Email": @email,
                "SendAccountNews": "YES",
                "SendWarnings": "YES"
              }
            },
            "TimeTargeting": {
              "Schedule": {
                "Items": @target_hours
              },
              "ConsiderWorkingWeekends": "YES",
              "HolidaysSchedule": {
                "SuspendOnHolidays": "NO",
                "BidPercent": 100,
                "StartHour": 0,
                "EndHour": 24
              } 
            },
            "TimeZone": @time_zone
          }
    hash["NegativeKeywords"] = @negative_keywords if @negative_keywords.present?
    hash["DailyBudget"] = {"Amount": @daily_budget_amount, "Mode": @daily_budget_mode} if @daily_budget_mode.present? && @daily_budget_amount.present?
    hash["BlockedIps"] = {"Items": @blocked_ips} if @blocked_ips.present?
    hash["ExcludedSites"] = {"Items": @excluded_sites} if @excluded_sites.present?
    hash["Id"] = @id if @id.present? && @id != 0
    hash["StartDate"] = @start_date if @start_date.present?
    hash["EndDate"] = @end_date if @end_date.present?
    hash[campaign_type.first] = campaign_type.last
    hash
  end

  def text_campaign_parameters
    ["TextCampaign", {"BiddingStrategy": {
                        "Search": {
                          "BiddingStrategyType": @search_strategy
                        }, 
                        "Network": { 
                          "BiddingStrategyType": @network_strategy,
                          "NetworkDefault": {
                            "LimitPercent": @limit_percent,
                            "BidPercent": @bid_percent
                          }
                        }
                      }
                    }
    ]
  end

  private

  def batch_add(campaigns)
    params = []
    campaigns.each do |campaign|
      special_parameters = campaign.text_campaign_parameters if campaign.type.blank? || campaign.type == "TEXT_CAMPAIGN"
      params.push(campaign.parameters(special_parameters))
    end
    params.each_slice(10) do |add_parameters|
      @client.request(SERVICE, 'add', {"Campaigns": add_parameters.compact})["AddResults"].map{|r| r["Id"]}
    end
  end

  def batch_update(campaigns)
    params = []
    campaigns.each do |campaign|
      special_parameters = campaign.text_campaign_parameters if campaign.type.blank? || campaign.type == "TEXT_CAMPAIGN"
      params.push(campaign.parameters(special_parameters))
    end
    params.each_slice(10) do |add_parameters|
      @client.request(SERVICE, 'update', {"Campaigns": add_parameters.compact})["UpdateResults"].map{|r| r["Id"]}
    end
  end
end

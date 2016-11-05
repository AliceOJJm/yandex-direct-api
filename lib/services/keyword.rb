class YandexDirect::Keyword
  SERVICE = 'keywords'

  def initialize(client)
    @client = client
  end
  
  def add(params)
    keywords = params.map do |word|
      param = { "Keyword": word[:word],
        "AdGroupId": word[:ad_group_id],
        "StrategyPriority": word[:strategy_priority] || "NORMAL"
      }
      param["Bid"] = word[:bid] if word[:bid].present?
      param["ContextBid"] = word[:context_bid] if word[:context_bid].present?
      param
    end
    keywords.any? ? @client.request(SERVICE, 'add', {"Keywords": keywords})["AddResults"] : []
  end

  def get(params)
    selection_criteria = {"States":  ["ON"], "Statuses": ["ACCEPTED", "DRAFT"]}
    selection_criteria["CampaignIds"] = params[:campaign_ids] if params[:campaign_ids].present?
    selection_criteria["Ids"] = params[:ids] if params[:ids].present?
    selection_criteria["AdGroupIds"] = params[:ad_group_ids] if params[:ad_group_ids].present?
    @client.request(SERVICE, 'get', { 
      "SelectionCriteria": selection_criteria,
      "FieldNames": ["Id", "Keyword", "State", "Status", "AdGroupId", "CampaignId", "Bid", "ContextBid"]
    })["Keywords"] || []
  end

  def update(keywords)
    keywords.map! do |word|
      { "Id": word[:id],
        "Keyword": word[:word]
      }
    end
    @client.request(SERVICE, 'update', {"Keywords": keywords.uniq})["AddResults"]
  end

  def delete(ids)
    ids = ids.compact.uniq.reject{|id| id == 0}
    @client.request(SERVICE, 'delete', {"SelectionCriteria": {"Ids": ids}}) if ids.any?
  end
end

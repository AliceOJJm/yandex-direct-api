require 'net/http'
require 'net/https'
require 'json'
require 'yaml'
require 'uri'

module YandexDirect
  class RuntimeError < RuntimeError
  end

  def self.url
    configuration['sandbox'] ? 'https://api-sandbox.direct.yandex.com/json/v5/' : 'https://api.direct.yandex.com/json/v5/'
  end

  def self.configuration
    if defined? @environment
      raise RuntimeError.new("Configure yandex-direct-api for #{@environment} environment.") unless @configuration
    else
      raise RuntimeError.new('Configure yandex-direct-api for current environment.') unless @configuration
    end
    @configuration
  end

  def self.parse_json json
    begin
      return JSON.parse(json)
    rescue => e
      raise RuntimeError.new "#{e.message} in response."
    end
  end
  
  def self.load file, env = nil
    @environment = env.to_s if env
    config = YAML.load_file(file)
    @configuration = defined?(@environment) ? config[@environment] : config
  end

  def self.configure options
    @configuration = options
  end

  def self.request(service, method, params = {}, units = false, config: @configuration)
    uri = URI(url + service)
    body = {
      method: method,
      params: params
    }
    puts "\t\033[32mYandexDirect:\033[0m #{service}.#{method}(#{body[:params]})" if config['verbose'] && !units
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # http.set_debug_output($stdout) 
    request = Net::HTTP::Post.new(uri.path)
    request['Authorization'] = "Bearer #{config['token']}"
    request['Accept-Language'] = config['locale']
    request['Client-Login'] = config['login'].downcase.gsub('.', '-')
    request.body = JSON.generate(body)

    response = http.start do |http| 
      http.request(request)
    end

    raise YandexDirect::RuntimeError.new("#{response.code} - #{response.message}") unless response.code.to_i == 200

    return response['Units'] if units

    json = parse_json(response.body)
    messages = []
    if json.has_key?('error')
      messages.push("#{json['error']['error_code'].to_i} - #{json['error']['error_string']}: #{json['error']['error_detail']}") 
    else
      value = json['result'].present? ? (json['result'].values.first || json['result']) : json
      value = value.values if value.kind_of?(Hash)
      value.each do |item|
        item['Errors'].each do |error|
          messages.push("#{error['Code'].to_i} - #{error['Message']}: #{error['Details']}")
        end if item.has_key?('Errors')
      end if value.present?
    end
    raise RuntimeError.new(messages.join("\n")) if messages.any?
    return json['result']
  end

  def self.get_units
    units = request('dictionaries', 'get', {"DictionaryNames": ["AdCategories"]}, true)
    units.split('/')[1].to_i
  end
end

require 'services/campaign.rb'
require 'services/add.rb'
require 'services/ad_group.rb'
require 'services/keyword.rb'
require 'services/bid.rb'
require 'services/dictionaries.rb'
require 'services/sitelink.rb'
require 'services/vcard.rb'
require 'live/live.rb'
require 'client.rb'

require 'net/http'
require 'uri'

module GptApp
  module Web
    def self.download_file(url)
      `wget #{url}`
    end

    def self.get_url_information(url)
      uri = URI(url)
      response = Net::HTTP.get_response(uri)
      {
        code: response.code,
        message: response.message,
        header: response.header.to_hash
      }
    end
  end
end

require 'net/http'
require 'uri'

module GptApp
  module Web
    def download_file(url)
      `wget #{url}`
    end

    def get_url_information(url)
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

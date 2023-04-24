
module GptApp 
  module Images
    def self.generate_image(openai_client, prompt, size="256x256")
      response = openai_client.images.generate(parameters: { prompt: prompt, size: size })
      url = response.dig("data", 0, "url")
      [response, url]
    end

  end
end
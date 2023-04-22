
module GptApp 
  module Images
    def generate_image(openai_client, prompt, size="256x256")
      openai_client.images.generate(parameters: { prompt: prompt, size: size })
    end
  end
end
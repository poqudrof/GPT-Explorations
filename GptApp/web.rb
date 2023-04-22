
module GptApp 
  module web 
    def download_file(url)
      `wget #{}`
    end
  end
end

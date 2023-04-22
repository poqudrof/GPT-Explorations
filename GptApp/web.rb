
module GptApp 
  module Web 
    def download_file(url)
      `wget #{}`
    end
  end
end

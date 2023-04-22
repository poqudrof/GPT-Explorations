
module GptApp 
  module Web 
    def download_file(url)
      `wget #{url}`
    end
  end
end

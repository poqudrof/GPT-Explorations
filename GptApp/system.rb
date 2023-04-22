
module GptApp 
  module System 
    def list_files 
      `ls`
    end

    def read_file(file_name)
      File.read(file_name)
    end
  end
end

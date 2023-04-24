
module GptApp 
  module System 
    def self.list_files 
      `ls`
    end

    def self.read_file(file_name)
      File.read(file_name)
    end
    
    def self.running_processes
      `ps aux`
    end
  end
end

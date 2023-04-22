require 'dotenv/load'
require "openai"
require 'pry'
require 'colorize'

OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_API_KEY")
  config.organization_id = ENV.fetch("OPENAI_ORG")
end

def with_captured_stdout
  original_stdout = $stdout  # capture previous value of $stdout
  $stdout = StringIO.new     # assign a string buffer to $stdout
  yield                      # perform the body of the user code
  $stdout.string             # return the contents of the string buffer
ensure
  $stdout = original_stdout  # restore $stdout to its previous value
end

client = OpenAI::Client.new
# client.models.list

## Interactive programming mode using Pry

## Notes
roles = ["user", "system", "assistant"] ## system, user, or assistant
## GPT4

## First app
APP_FOLDER="GptApp"

## API 
def current_api 
  files = Dir.entries(APP_FOLDER)
      .reject { |file| file.start_with? "." }
      .map {|file| "FILE:#{file}: \n" + `cat #{APP_FOLDER}/#{file}` + "\n" } 
      .reduce("") { |contents, entry| contents + entry }  
  ## For one file
  # "FILE:system.rb: \n" + `cat #{APP_FOLDER}/system.rb` + "\n"
end

## Autoload the folder 

def reload!(print = true)
  puts 'Reloading ...' if print
  # Main project directory.
  root_dir = File.expand_path('.', __dir__)
  # Directories within the project that should be reloaded.
  reload_dirs = [APP_FOLDER]
  # Loop through and reload every file in all relevant project directories.
  reload_dirs.each do |dir|
    Dir.glob("#{root_dir}/#{dir}/*.rb").each { |f| load(f) }
  end
  # Return true when complete.
  true
end

reload!

## Load add dependencies
#require "./#{APP_FOLDER}/system.rb"
#require_relative "./#{APP_FOLDER}/web.rb"
##require "./#{APP_FOLDER}/system.rb"

# require_relative "./conversation.rb"


# messages = []

# ## System 
# messages.push({ role: "system", content: "You are a ruby program and interpreter. You respond only by writing ruby code without non-ruby annotations to that it should run. When asking the user to run code, the message should start with RUN_CODE: . All the modules from #{APP_FOLDER} are already loaded." })
# messages.push({ role: "user", content: "You can ask the user to run ruby code for you."})
# messages.push({ role: "assistant", content: "Ok, show me how with this code : \n ```ruby\n puts(\"Hello World\") \n```"})
# messages.push({ role: "user", content: "Run it"})
# messages.push({ role: "assistant", content: "RUN_CODE: ```ruby\n puts(\"Hello World\") \n```"})
# messages.push({ role: "user", content: "CODE_OUTPUT: \"Hello World\" \n RETURN_VALUE: nil"})

# messages.push({ role: "user", content: "Here is your API : #{current_api}"})

## Start the loop here 

include GptApp 

conversation = Conversation.new(binding)

# binding.pry 

# cd conversation 
# continue_chat 
# ask_gpt

# @messages.pop  to remove a prompt / response
# load "conversation.rb"  to reload the file
 
conversation.start_chat

## Question 
# messages.push({ role: "user", content: "List the files in the current folder"})

#messages.push({ role: "user", content: "List the files in the current folder"})

"Add a new method in the system module to see the running processes."

## Call 
# response = client.chat(
#     parameters: {
#         model: "gpt-4", # Required.
#         max_tokens: 300,
#         messages: messages, # Required.
#         temperature: 0.8,
#     })

# ## add it to the conversation 
# messages.push response.dig("choices", 0, "message")


# content = response.dig("choices", 0, "message", "content")
# is_file = content.start_with? "FILE:"
# file_name = content.split("FILE:")[1].split(":\n")[0]
# response = content.split("FILE:")[1].split(":\n")[1]
# code = content.split("FILE:")[1].split(":\n")[1].split("```")[1].split("ruby")[1]

# full_file = "./#{APP_FOLDER}/#{file_name}"

# puts "Writing in #{full_file}..."
# File.write(full_file, code)

# ## Display answer
# puts "Here is the code : #{content}:"

# ## Reload ! dependencies
# load "./#{full_file}"





# response = client.images.generate(parameters: { prompt: "A baby sea otter cooking pasta wearing a hat of some sort", size: "256x256" })
# puts response.dig("data", 0, "url")

# => "https://oaidalleapiprodscus.blob.core.windows.net/private/org-Rf437IxKhh..."


## Read all files and instrospect them as context, then ask to call them.


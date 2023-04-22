require 'dotenv/load'
require "openai"
require 'pry'


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
# binding.pry 

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

## Load add dependencies
require "./#{APP_FOLDER}/system.rb"

messages = []

## System 
messages.push({ role: "system", content: "You are a ruby program and interpreter. You respond only by writing ruby code without non-ruby annotations to that it should run." })
messages.push({ role: "user", content: "You can ask the user to run ruby code for you."})
messages.push({ role: "assistant", content: "Ok, show me how with this code : \n ```ruby\n puts(\"Hello World\") \n```"})
messages.push({ role: "user", content: "Run it"})
messages.push({ role: "assistant", content: "RUN_CODE: ```ruby\n puts(\"Hello World\") \n```"})
messages.push({ role: "user", content: "CODE_OUTPUT: \"Hello World\" \n RETURN_VALUE: nil"})

messages.push({ role: "user", content: "Here is your API : #{current_api}"})
               
## Question 
messages.push({ role: "user", content: "List the files in the current folder"})

## Call 
response = client.chat(
    parameters: {
        model: "gpt-4", # Required.
        max_tokens: 300,
        messages: messages, # Required.
        temperature: 0.8,
    })

## add it to the conversation 
messages.push response.dig("choices", 0, "message")


is_code = response.dig("choices", 0, "message", "content").start_with? "RUN_CODE:"

if(is_code)
  code = response.dig("choices", 0, "message", "content").split("```")[1].split("ruby")[1]
   
  ## Ask the user if he wants to run it.
  should_run = gets.chomp == "y"

  if should_run 
    response = ""
    output = with_captured_stdout do 
      response = eval(code) 
    end

    messages.push({ role: "user", content: "CODE_OUTPUT: \"#{output}\" \n RETURN_VALUE: #{response}"})
  end 
end


response = client.chat(
    parameters: {
        model: "gpt-4", # Required.
        max_tokens: 300,
        messages: messages, # Required.
        temperature: 0.8,
    })

content = response.dig("choices", 0, "message", "content")
is_file = content.start_with? "FILE:"
file_name = content.split("FILE:")[1].split(":\n")[0]
response = content.split("FILE:")[1].split(":\n")[1]
code = content.split("FILE:")[1].split(":\n")[1].split("```")[1].split("ruby")[1]

full_file = "./#{APP_FOLDER}/#{file_name}"

puts "Writing in #{full_file}..."
File.write(full_file, code)

## Display answer
puts "Here is the code : #{content}:"

## Reload ! dependencies
load "./#{full_file}"





# response = client.images.generate(parameters: { prompt: "A baby sea otter cooking pasta wearing a hat of some sort", size: "256x256" })
# puts response.dig("data", 0, "url")

# => "https://oaidalleapiprodscus.blob.core.windows.net/private/org-Rf437IxKhh..."


## Read all files and instrospect them as context, then ask to call them.


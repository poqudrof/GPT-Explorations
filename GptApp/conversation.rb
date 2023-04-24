
class Conversation 
  attr_reader :last_message, :client, :messages

  def initialize(binding)
    @binding = binding
    @client = OpenAI::Client.new
    @messages = []
    @messages.push({ role: "system", content: "You are a ruby program and interpreter. You respond only by writing ruby code without non-ruby annotations to that it should run. When asking the user to run code, the message should start with RUN_CODE: . All the modules from #{APP_FOLDER} are already loaded." })
    @messages.push({ role: "user", content: "You can ask the user to run ruby code for you."})
    @messages.push({ role: "assistant", content: "Ok, show me how with this code : \n ```ruby\n puts(\"Hello World\") \n```"})
    @messages.push({ role: "user", content: "Run it"})
    @messages.push({ role: "assistant", content: "RUN_CODE: ```ruby\n puts(\"Hello World\") \n```"})
    @messages.push({ role: "user", content: "CODE_OUTPUT: \"Hello World\" \nRETURN_VALUE: nil"})
    load_api
    messages_history 
  end

  def load_api
    @messages[6] = ({ role: "user", content: "Here is your API : #{current_api}"})
  end
  
  def role_color
    %i(user system assistant).zip(%i(white blue green)).to_h 
  end

  def messages_history 
    @messages.each do |message|  
      show_message(message)
    end
  end

  def show_message(message)
    puts "#{message[:role]}: ".colorize(color: role_color[message[:role].to_sym], mode: :bold)
    puts "#{message[:content]}".colorize(role_color[message[:role].to_sym]) 
  end

  def start_chat
    puts "Write a message: "
    user_input = gets 

    if user_input.chomp.downcase == "exit"
      puts "Exiting the app..."
      exit
    end

    if user_input.chomp == "pry"  
      @binding.pry
      start_chat 
    end

    @messages.push({ role: "user", content: user_input})
    puts "Sending..."
    ask_gpt
    start_chat 
  end

  def ask_gpt 
    run_gpt 
    code_chat if(is_code? @last_message)
    file_chat if(is_file? @last_message)
  end

  def run_gpt
    response = @client.chat(
      parameters: {
          model: "gpt-4",
          max_tokens: 300,
          messages: @messages,
          temperature: 0.8,
      })

    @last_message = response.dig("choices", 0, "message")
    @last_message[:role] = @last_message["role"]
    @last_message[:content] = @last_message["content"]
    show_message @last_message
    @messages.push @last_message
  end

  ## Code answer
  def is_code?(message)
    message["content"].start_with? "RUN_CODE:"
  end

  def code_chat
    print "It is code !\n"
    code = @last_message["content"].split("```")[1].split("ruby")[1]
    puts code.colorize(:red)
    print "\nRun it ? (y/n)".colorize(mode: :bold)
    
    should_run = gets.chomp == "y"

    if should_run
      print "You decided to run this code."
      response = ""
      output = with_captured_stdout do 
        response = eval(code, @binding) 
      end
      message = { role: "user", content: "CODE_OUTPUT: \"#{output}\" \n RETURN_VALUE: #{response}"}
      show_message(message)
      @messages.push(message)

    else 
      print "Not running code, going back to chat."
    end
  end 

  ## File answer
  def is_file?(message)
    message["content"].start_with? "FILE:"
  end

  def file_chat
    content = @last_message["content"]

    is_file = content.start_with? "FILE:"
    file_name = content.split("FILE:")[1].split(":\n")[0]
    response = content.split("FILE:")[1].split(":\n")[1]
    code = content.split("FILE:")[1].split(":\n")[1].split("```")[1].split("ruby")[1]

    full_file = "./#{APP_FOLDER}/#{file_name}"

    print "A file is in the message !\n"
    puts "file: #{file_name}".colorize(mode: :bold)
    puts code.colorize(:red)

    ## Check if exists...
    if File.exists? full_file
      puts "Your Original file: #{file_name}".colorize(mode: :bold)
      puts File.read(full_file).colorize(:blue)
      print "\nReplace the current ? (y/n)".colorize(mode: :bold)
    else 
      puts "It is a new file: #{file_name}".colorize(mode: :bold)
      print "\nWrite it ? (y/n)".colorize(mode: :bold)
    end

    ## Ask the user if he wants to run it.
    should_write = gets.chomp == "y"

    if should_write
      puts "Writing in #{full_file}..."
      File.write(full_file, code)

      puts "Try to reload it"
      ## Reload ! dependencies
      load full_file
    else 
      puts "Not writing"
    end

  end
end
require 'dotenv/load'
require "openai"

client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

puts "Hello World"

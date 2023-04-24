# GPT-Explorations

## Goal 

Initial: Create a way to program and communicate with GPT-4 to make use it in new ways. 

New goal: Create a Ruby program and API that writes itself interactively like AutoGPT.


## Run 

Use the API here is a prompt : 

> `List the files in the current folder`

Generate an image: 

> `generate an image with this prompt "A beautiful cat sitting in the sun", download the url with our API.`

## Use in Ruby with Pry

Type `pry` instead of prompt. You can then interact using ruby. 

Go in to the conversion `cd conversation` : 
You can update the `@messages` array, then send it to GPT using `ask_gpt`. 

Or call your modules and methods : 

``` ruby
include GptApp::Web
download_file "http://google.com"
```

`GptApp::Web::download_file "http://google.com`

## Extend the app 

### Modules 

Update a module: 


> `Update the Web module with commands to get informations about an URL.`

### Conversation 

Prompt to update an existing method: 

> `In class Conversation add the possiblity to write "exit" to leave the app in the methode "start_chat". Write only this method.`

### With Docker and Docker compose 

`docker compose run --build  ruby_app`


### Update Gemfile.lock 

`docker build -t gpt-gemfile -f Dockerfile.bundler . && docker run  -v "$(pwd):/home/appuser" --rm -p 3000:3000 --name gpt-gem-run gpt-gemfile`


## Shortcuts 

* Playground: https://platform.openai.com/playground?mode=chat&model=gpt-4
* AutoGPT: https://github.com/Significant-Gravitas/Auto-GPT
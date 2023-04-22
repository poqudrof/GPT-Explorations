# GPT-Explorations

## Goal 

Initial: Create a way to program and communicate with GPT-4 to make use it in new ways. 

New goal: Create a Ruby program and API that writes itself interactively like AutoGPT.


## Run 


### With Docker and Docker compose 

docker compose run --build  ruby_app    


### Update Gemfile.lock 

docker build -t gpt-gemfile -f Dockerfile.bundler . && docker run  -v "$(pwd):/home/appuser" --rm -p 3000:3000 --name gpt-gem-run gpt-gemfile


## Shortcuts 

* Playground: https://platform.openai.com/playground?mode=chat&model=gpt-4
* AutoGPT: https://github.com/Significant-Gravitas/Auto-GPT
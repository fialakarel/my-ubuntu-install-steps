#!/bin/bash

set -ve

# Install python build deps
sudo apt update
sudo apt install --yes bzip2 openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev gcc build-essential zlib1g zlib1g-dev

# Install pyenv
curl https://pyenv.run | bash

# Create pyenv for poetry
pyenv install 3.8.3

# Install Poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3

# Install Poetry bash completion
poetry completions bash | sudo tee /etc/bash_completion.d/poetry.bash-completion >/dev/null

Chef.io repository
==================

# Chef Configuration
This repo contains chef configuration scripts that I use for various platforms, experiments and learning.

## Installation
To get started, you'll need to install Ruby, Chef and download the setup file.  Here's how!

### Install ruby
```bash
  subo apt-get update
  sudo apt-get install ruby
```

### Install Chef
Install the Chef client
```bash
  wget -q -O - https://www.chef.io/chef/install.sh | sudo bash
```

### Download setup.rb
To download the setup.rb, issue the following from a fresh terminal window:
```bash
  wget https://raw.githubusercontent.com/dachew/chef/master/ubuntu-laptop/setup.rb -O setup.rb
```

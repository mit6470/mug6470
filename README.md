# Interactive ML

An interactive machine learning tutorials and tools application based on Ruby on
Rails framework.

## Setting up the development environment for Rails 3

* OS: Ubuntu 11.10
* Update Ruby to 1.9.2 on Ubuntu 11.10
    
    $ sudo apt-get remove ruby rubygems ruby1.8 ruby1.8-dev ruby1.8-full
    
    $ sudo apt-get install ruby1.9.1-full
    
    $ sudo update-alternatives --set ruby /usr/bin/ruby1.9.1
    
    $ sudo env REALLY_GEM_UPDATE_SYSTEM=1 gem update --system
    
* Update Ruby to 1.9.2 on Ubuntu < 11.10.

    $ sudo apt-get remove --purge ruby rubygems ruby1.8 ruby1.8-dev ruby1.8-full
    
    $ sudo apt-get install ruby1.9.1-full

    $ sudo update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 0

    $ sudo update-alternatives --install /usr/bin/gem gem /usr/bin/gim1.9.1 0

    $ sudo update-alternatives --install /usr/bin/ri ri /usr/bin/ri1.9.1 0

    $ sudo update-alternatives --install /usr/bin/irb irb /usr/bin/irb1.9.1 0
    
    $ sudo env REALLY_GEM_UPDATE_SYSTEM=1 gem update --system

* Libraries needed for Rails development

    $ sudo apt-get install build-essential 
    
    $ sudo apt-get install mysql-server mysql-client libmysqlclient-dev
    
    $ sudo apt-get install sqlite3 libsqlite3-dev
    
    $ sudo gem install bundler
    
## Setting up the application

* Install all necessary gems, In the project's directory:
    
    $ bundle install
    
* Database setup.

    $ rake db:drop db:create db:migrate db:seed
    
* Start the server.

    $ rails s


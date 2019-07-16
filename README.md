# Webshot
Just another tool to screenshot web servers
https://www.pentestgeek.com/ptgforums/viewtopic.php?id=18

# Installation
    $ bundle install

For some reason the thread gem isn't installing via bundle install so install it manually.

    $ gem install thread

Webshot utilized the wkhtmltoimage binary which unfortuently is stuck on libpng12.  Download the .deb package from [https://packages.ubuntu.com/xenial/amd64/libpng12-0/download](https://packages.ubuntu.com/xenial/amd64/libpng12-0/download) and install it with `dpkg -i`

    $ sudo dpkg -i libpng12-0_1.2.54-1ubuntu1.1_amd64.deb

# Help
    $ ./webshot.rb -h
    Webshot.rb VERSION: 0.2 - UPDATED: 9/07/2017

    References:
      https://www.pentestgeek.com/ptgforums/viewtopic.php?id=18

    Usage: ./webshot.rb [options] [target list]

				-t, --targets [Nmap XML File]    XML Output From Nmap Scan
        -o, --output [Output Directory]  Path to file where screenshots will be stored
        -T, --threads [Thread Count]     Integer value between 1-20 (Default is 10)
        -v, --verbose                    Enables verbose output

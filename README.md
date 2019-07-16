# Webshot
Just another tool to screenshot web servers.

## Installation
    $ bundle install

For some reason the thread gem isn't installing via bundle install so install it manually.

    $ gem install thread

Webshot utilized the wkhtmltoimage binary which unfortuently is stuck on libpng12.  Download the .deb package from [https://packages.ubuntu.com/xenial/amd64/libpng12-0/download](https://packages.ubuntu.com/xenial/amd64/libpng12-0/download) and install it with `dpkg -i`

    $ sudo dpkg -i libpng12-0_1.2.54-1ubuntu1.1_amd64.deb

## Help
    $ ./webshot.rb -h
    Webshot.rb VERSION: 1.1 - UPDATED: 7/16/2019

    References:
            https://github.com/R3dy/webshot

    Usage: ./webshot.rb [options] [target list]

        -t, --targets [Nmap XML File]    XML Output From Nmap Scan
        -c, --css [CSS File]             File containing css to apply to all screenshtos
        -u, --url [Single URL]           Single URL to take a screenshot
        -U, --url-file [URL File]        Text file containing URLs, one on each line
        -o, --output [Output Directory]  Path to file where screenshots will be stored
        -T, --threads [Thread Count]     Integer value between 1-20 (Default is 10)
        -v, --verbose                    Enables verbose output



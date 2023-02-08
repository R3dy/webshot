# Webshot
Just another tool to screenshot web servers.

## Installation
    $ bundle install

For some reason the thread gem isn't installing via bundle install so install it manually.

    $ gem install thread

Download the correct wkhtmltopdf package for your distribution from [https://wkhtmltopdf.org/downloads.html](https://wkhtmltopdf.org/downloads.html) and install with ```dpkg -i```. The current version tested and working with Kali from capsulecorp is ```wkhtmltox_0.12.6.1-2.bullseye_amd64.deb```

    $ sudo dpkg -i wkhtmltox_0.12.6.1-2.bullseye_amd64.deb

You will also need to install libssl for wkhtmltopdf

    $ sudo apt install libssl1.1

IF you are still having issues, Webshot utilized the wkhtmltoimage binary which is stuck on libpng12.  Download the .deb package from [https://packages.ubuntu.com/xenial/amd64/libpng12-0/download](https://packages.ubuntu.com/xenial/amd64/libpng12-0/download) and install it with `dpkg -i`

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



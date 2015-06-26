# Webshot
Just another tool to screenshot web servers

# Installation
    $bundle install

# Help
    $ ./webshot.rb -h
    Webshot.rb VERSION: 0.1 - UPDATED: 6/26/2015

    References:
      https://www.pentestgeek.com/ptgforums/index.php

    Usage: ./webshot.rb [options] [target list]

        -t, --targets [Hosts File]       File containing [IP Address]:[Port]
        -o, --output [Output Directory]  Path to file where screenshots will be stored
        -T, --threads [Thread Count]     Integer value between 1-20 (Default is 10)
        -v, --verbose                    Enables verbose output

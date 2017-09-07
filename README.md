# Webshot
Just another tool to screenshot web servers
https://www.pentestgeek.com/ptgforums/viewtopic.php?id=18

# Installation
    $bundle install

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

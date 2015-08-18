#!/usr/bin/env ruby
begin
  require 'imgkit'
  require 'pry'
  require 'thread/pool'
  require 'optparse'
rescue LoadError
  puts "Error resolving dependencies.  Run \'bundle install\' first"
  exit!
end

unless ARGV.length > 0
  puts "Try ./webshot.rb -h\r\n\r\n"
  exit!
end

@options = {}
args = OptionParser.new do |opts|
  opts.banner = "Webshot.rb VERSION: 0.1 - UPDATED: 6/26/2015\r\n\r\n"
  opts.banner += "References:\r\n"
  opts.banner += "\thttps://www.pentestgeek.com/ptgforums/index.php\r\n\r\n"
  opts.banner += "Usage: ./webshot.rb [options] [target list]\r\n\r\n"
  opts.on("-t", "--targets [Hosts File]", "File containing [IP Address]:[Port]") { |targets| @options[:targets] = File.open(targets, "r").read }
  opts.on("-o", "--output [Output Directory]", "Path to file where screenshots will be stored") { |output| @options[:output] = output.chomp }
  opts.on("-T", "--threads [Thread Count]", "Integer value between 1-20 (Default is 10)") { |threads| @options[:threads] = threads.to_i }
  opts.on("-v", "--verbose", "Enables verbose output\r\n\r\n") { |v| @options[:verbose] = true }
end
args.parse!(ARGV)

if @options[:threads]
  if @options[:threads] > 20 || @options[:threads] < 1
    puts "Error: Thread count must be an integer value between 1 & 20"
    exit!
  else
    @threads = Thread.pool(@options[:threads])
  end
else
  @threads = Thread.pool(10)
end
puts "Thread count set to #{@threads.max.to_s}." if @options[:verbose]

IMGKit.configure do |config|
  config.default_options = {
    quality: 25,
    height: 600,
    width: 800,
    # If the website happens to offer up an auth prompt.
    # No harm in trying admin/admin while we're here...
    username: 'admin',
    password: 'admin',
    'load-error-handling' => 'ignore'
  }
end
 
def get_url(ip)
  host = ip.split(":")[0]
  port = ip.split(":")[1]
  if port == "443"
    "https://#{host}:#{port}/"
  else
    "http://#{host}:#{port}/"
  end
end
 
def get_screenshot(url)
  begin
    puts "Taking screenshot: #{url}" if @options[:verbose]
    screenshot = IMGKit.new(url, quality: 25, height: 600, width: 800)
  rescue => error
    puts error
    return nil
  end
  return screenshot
end
 
@options[:targets].each_line do |target|
  @threads.process {
    url = get_url(target.chomp)
    screenshot = get_screenshot(url)
    if screenshot
      begin
        screenshot.to_file("#{@options[:output]}/#{target.chomp.gsub(/:/,'_')}.png")
      rescue => error
        if error.message.include? "No such file or directory"
          puts "Directory \"#{@options[:output]}\" does not exist."
          exit!
        end
        next
      end
    end
  }
end
@threads.shutdown

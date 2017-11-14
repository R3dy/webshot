#!/usr/bin/env ruby
begin
	require 'imgkit'
	require 'pry'
	require 'thread/pool'
	require 'optparse'
	require 'nmap/parser'
	require 'nokogiri'
	require 'net/https'
	require 'openssl'
rescue LoadError => msg
	puts msg.message.chomp + " try running \'bundle install\' first"
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
		opts.on("-t", "--targets [Nmap XML File]", "XML Output From Nmap Scan") { |targets| @options[:targets] = File.open(targets, "r").read }
		opts.on("-u", "--url [Single URL]", "Single URL to take a screenshot") { |url| @options[:url] = url.chomp }
		opts.on("-o", "--output [Output Directory]", "Path to file where screenshots will be stored") { |output| @options[:output] = output.chomp }
		opts.on("-T", "--threads [Thread Count]", "Integer value between 1-20 (Default is 10)") { |threads| @options[:threads] = threads.to_i }
		opts.on("-v", "--verbose", "Enables verbose output\r\n\r\n") { |v| @options[:verbose] = true }
	end
args.parse!(ARGV)

@options[:urls] = Array.new
if @options[:targets]
	puts "Extracting URLs from Nmap scan"
	xml = Nokogiri::XML(@options[:targets])
	xml.xpath("//host")[1..-1].each do |host|
		ip = host.css('address').attr('addr').text
		host.css("port").each do |p|
			if p.css('state').attr('state').value == "open"
				port = p.attr('portid')
				proto = p.css('service').attr('name').text.split('-')[0]
				if proto.include? 'http'
					the_url_http = "http://#{ip}:#{port}"
					the_url_https = "https://#{ip}:#{port}"
					@options[:urls] << the_url_http.chomp
					@options[:urls] << the_url_https.chomp
				end
			end
		end
	end
end

@options[:urls] << @options[:url] if @options[:url]

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

puts "Configuring IMGKit options"
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

def setup_http(url, use_ssl)
	uri = URI.parse(url)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = use_ssl
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE if use_ssl
	return http
end
 
def get_screenshot(url)
	begin
		puts "Taking screenshot: #{url}" if @options[:verbose]
		headers = {}
		use_ssl = url.include? 'https'
		http = setup_http(url, use_ssl)
		response = http.get('/', {})
		screenshot = IMGKit.new(response.body, quality: 25, height: 600, width: 800) if response.code == "200"
	rescue => error
		puts error
		return nil
	end
	return screenshot
end

puts "Capturing #{@options[:urls].size.to_s} screenshots using #{@threads.max.to_s} threads"
@options[:urls].each do |url|
  @threads.process {
		screenshot = get_screenshot(url)
		if screenshot
			begin
				ip = url.split('//')[1]
				file = screenshot.to_file("#{@options[:output]}/#{ip.gsub(/[:\/]/,'_')}.png")
				FileUtils.rm(file.path) unless file.size > 3273
			rescue => error
				if error.message.include? "No such file or directory"
					puts "Directory \"#{@options[:output]}\" does not exist."
					return
				end
				next
			end
		end
  }
end
@threads.shutdown

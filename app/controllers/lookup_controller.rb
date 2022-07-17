class LookupController < ApplicationController
  before_action :configure_lookup_params
  # validates :lookup, presence: true, length: { maximum: 10 }

  require "addressable/uri"
  require "public_suffix"
  require "whois-parser"

  def show

    if params[:lookup].present?

      # Get user-submitted Lookup data from params, strip all whitespace and gsub replace all spaces with nothing
      # lookup = params[:lookup].strip.gsub(/ /, "").gsub("'", "")
      lookup = params[:lookup].strip
      puts "Lookup: #{lookup}"

      # Escape characters in lookup
      escaped_lookup = Addressable::URI.escape(lookup)

      # Remove illegal characters
      new_lookup = escaped_lookup.gsub(/ |'|/, "")
      
      # Parse lookup data
      parsed_lookup = URI.parse(new_lookup)

      puts "Parsed Lookup: #{parsed_lookup.to_s}"
      
      scheme = parsed_lookup.scheme.to_s
      host = parsed_lookup.host.to_s
      path = parsed_lookup.path.to_s
      fragment = parsed_lookup.fragment.to_s

      puts "Scheme: #{scheme}"
      puts "Host: #{host}"
      puts "Path: #{path}"

      # If 'scheme' and 'host' are both nil, change 'scheme' to 'http' and move 'path' data to 'host' (unless path is also nil)
      if parsed_lookup.scheme.nil? && parsed_lookup.host.nil?
        unless parsed_lookup.path.nil?
          parsed_lookup.scheme = "http"
          parsed_lookup.host = parsed_lookup.path
          parsed_lookup.path = ""
        end
      end

      scheme = parsed_lookup.scheme.to_s
      host = parsed_lookup.host.to_s
      path = parsed_lookup.path.to_s
      port = parsed_lookup.port.to_s

      puts "Replaced Lookup: #{parsed_lookup}"

      puts "Replaced Scheme: #{scheme}"
      puts "Replaced Host: #{host}"
      puts "Replaced Path: #{path}"

      new_lookup = URI::HTTP.build(scheme: scheme, host: host, path: path)

      puts "Processed Lookup: #{new_lookup}"

      # Remove 'www.' if present from host or path
      if host.match(/^www\./)
        host = host.gsub(/^www\./, '')
        new_lookup.host = host
        # lookup = uri.to_s
        puts "host Removed www"
      elsif path.match(/^www\./)
        path = path.gsub(/^www\./, '')
        new_lookup.path = path
        # lookup = uri.to_s
        puts "path Removed www"
      else
        puts "No host match for \'www\'"
      end

      puts "Final lookup: #{new_lookup}"

      # Call manualValidation function and pass @lookup
      getDomain(new_lookup)

    else

      redirect_to(homepage_path)

    end

  end


  # private

  def getDomain(new_lookup)

    url = new_lookup

    p "getDomain Lookup: #{url}"

    # url_pattern = /https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,}/      
    # ip_pattern = /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/

    # if url =~ url_pattern
    if url.present?

      # Extract domain
      domain = Addressable::URI.parse(url).domain
      puts "Valid Domain: #{domain}"

      # Call getResponse function and pass @domain
      getResponse(domain)

    # elsif url =~ ip_pattern

    #   puts "Valid IP: #{url}"

    else

      p "Invalid URL: #{url}"
      flash.now[:alert] = "Lookup failed, invalid URL"
      @resultHeading = "No match"
      return @resultHeading

    end

  end


  def getResponse(domain)

    if domain.present?

      p "Domain NOT NIL: #{domain}"

      # Validate domain, tld designated 'nil' if not listed
      validity = PublicSuffix.valid?(domain, default_rule: nil)

      p "Valid domain? #{validity}"

      if validity == true
        # Use Whois gem to get Whois response for domain
        response = Whois.lookup(domain)
      else
        # "No match" flash message, return heading
        flash.now[:alert] = "Lookup failed, invalid domain"
        @resultHeading = "No match"
        return @resultHeading
      end

    else

      # "No match" flash message, return heading
      flash.now[:alert] = "Lookup failed, match not found"
      @resultHeading = "No match"
      return @resultHeading

    end

    if response.present?

      puts "Response: #{response}"

      # Get Whois record
      result = response.content

      if result.start_with?("Domain Name:", "   Domain Name:", "This Registry database")

        flash.now[:success] = "Lookup successful"

        @resultHeading = domain

        # Make all hyperlinks clickable in Whois record
        @result = result.gsub(/https?:\/\/.*/, '<a href="\0">\0</a>').html_safe

        # Have URL show user query
        # redirect_to :action => @domain

      elsif result.start_with?("   No match for")

        flash.now[:alert] = "Lookup failed, record not found"
        @resultHeading = "No match for #{domain}"
        return @resultHeading

      else

        flash.now[:warning] = "Lookup error, please try again"
        @resultHeading = "No match"
        return @resultHeading

      end

    else

      return

    end

  end


  protected

  def configure_lookup_params
    params.permit(:lookup)
    # params.require(:lookup)
  end


end

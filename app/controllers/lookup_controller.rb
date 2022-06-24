class LookupController < ApplicationController
  before_action :configure_lookup_params

  def show

    if params[:lookup].present?

      # Get user-submitted Lookup data from params, strip and gsub all whitespace
      @lookup = params[:lookup].strip.gsub(/ /, "")
      p "Lookup: #@lookup"

      # Call manualValidation function and pass @lookup
      manualValidation(@lookup)

    else

      # "Lookup failed" flash message, return "No match" heading
      flash[:alert] = "Lookup failed"
      @resultHeading = "No match"
      return @resultHeading

    end

  end


  private

  def manualValidation(lookup)
      
    # Lookup starts with "https://" but not "https://www."
    if ( @lookup.start_with?("https://") && @lookup !~ /https:\/\/www./ )
      
      @url = @lookup

    # Lookup starts with "https://www."
    elsif @lookup.start_with?("https://www.")

      @url = @lookup.sub("https://www.", "https://")

    # Lookup starts with "http://" but not "http://www."
    elsif ( @lookup.start_with?("http://") && @lookup !~ /http:\/\/www./ ) 

      @url = @lookup.sub("http", "https")

    # Lookup starts with "http://www."
    elsif @lookup.start_with?("http://www.")

      @url = @lookup.sub("http://www.", "https://")

    # Lookup starts with "www."
    elsif @lookup.start_with?("www.")

      @url = @lookup.sub("www.", "https://")

    else
    
      @url = ("https://#@lookup")

    end

    # Call getDomain function and pass @url
    getDomain(@url)

  end


  def getDomain(url)
    require 'net/http'
    # require "uri"
    require "open-uri"

    # Get status for URL, retry set amount of times for redirects, catch SocketError and return "No match"
    tries = 3
    begin
      @status = ( URI(url).open(redirect: false) ).status
    rescue OpenURI::HTTPRedirect => redirect
      uri = redirect.uri # taken from the "Location" response header
      retry if (tries -= 1) > 0
      raise
    rescue SocketError => e
      # p e.class
      # "No match" flash message, return heading
      flash[:alert] = "Lookup failed"
      @resultHeading = "No match"
      return @resultHeading
    end

    # If status OK, parse Lookup URL and extract domain
    if @status == ["200", "OK"]
                      
      p "Status OK: #@status"
      
      # Extract domain
      @domain = URI(url).host

      # Call getResponse function and pass @domain
      getResponse(@domain)

    else

      # "No match" flash message, return heading
      flash[:alert] = "Lookup failed"
      @resultHeading = "No match"
      return @resultHeading

    end

  end


  def getResponse(domain)
    require "public_suffix"
    # require "uri"
    require "whois-parser"

    if @domain.present?

      p "Domain NOT NIL: #@domain"
      
      # Validate domain, tld designated 'nil' if not listed
      @validity = PublicSuffix.valid?(@domain, default_rule: nil)

      p "Valid? #@validity"

      # Use Whois gem to get Whois response for domain
      @response = Whois.lookup(@domain)
    
    else

      # "No match" flash message, return heading
      flash[:alert] = "Lookup failed"
      @resultHeading = "No match"
      return @resultHeading

    end


    if response.present?

      # Get Whois record
      @result = @response.content
      
      if @result.start_with?("Domain Name:", "   Domain Name:")

        flash[:success] = "Lookup successful"

        @resultHeading = @domain

        # Make all hyperlinks clickable in Whois record
        @result = @result.gsub(/https?:\/\/.*/, '<a href="\0">\0</a>').html_safe

        # Have URL show user query
        # redirect_to :action => @domain

      elsif @result.start_with?("   No match for")
        
        flash[:alert] = "Lookup failed"
        @resultHeading = "No match for #@domain"
        return @resultHeading
      
      else
      
        flash[:warning] = "Lookup error, please try again"
        @resultHeading = "No match" 
        return @resultHeading
      
      end

    else

      return

    end

  end


  protected

  def configure_lookup_params
    params.permit(:lookup, :commit)
  end


end

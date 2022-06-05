class LookupController < ApplicationController
  before_action :configure_lookup_params

  def show
    require "uri"
    require "public_suffix"
    require "open-uri"

    if params[:lookup].present?

      # Get user-submitted Lookup data from params # https://www.tumblrgallery.xyz/tumblrblog/1152853.html
      @lookup = params[:lookup]
      p "Lookup: #@lookup"

      # Check if lookup data 
      if @lookup.start_with?("https://") == true
        
        @url = @lookup
        p "Lookup starts with correct scheme"

      elsif @lookup.start_with?("http://") == true

        @url = @lookup.sub("http", "https")
        p "Wrong protocol, new Lookup: #@url"
      
      else
      
        @url = ("https://#@lookup")
        p "Protocol missing, new Lookup: #@url"

      end

      # Call parseURL function and pass @url
      parseURL(@url)

    else

      # FLASH MESSAGE
      flash[:alert] = "Lookup failed"
      p "Invalid lookup 1"
      return

    end

  end


  private
  
  def parseURL(url)

    uri = URI.parse(url)
    tries = 3

    begin
      @status = uri.open(redirect: false).status
    rescue OpenURI::HTTPRedirect => redirect
      uri = redirect.uri # assigned from the "Location" response header
      retry if (tries -= 1) > 0
      raise
    end

    # If status OK, parse Lookup URL and extract domain
    if @status == ["200", "OK"]
                      
      p "Status OK: #@status"
      
      # Extract domain
      @domain = URI(url).host

    else

      # FLASH MESSAGE
      flash[:alert] = "Lookup failed"
      p "Invalid lookup 2"
      # EXIT

    end

    if @domain.present?

      p "Domain NOT NIL: #@domain"
      
      # Validate domain, tld designated 'nil' if not listed
      @validity = PublicSuffix.valid?(@domain, default_rule: nil)

      p "Valid? #@validity"

      # Use Whois gem to get Whois response for domain
      @response = Whois.whois(@domain)
    
    else

      p "Domain IS NIL: #@domain"
      # FLASH MESSAGE
      p "Invalid lookup 3"
      # EXIT

    end

    # FOR "www.miakhalifa.com"
    # @result = @response.to_s.split(">>>").first
    @result = @response.to_s.strip

    if @result.start_with?("Domain Name:")
      flash[:success] = "Lookup successful"
    elsif @result.start_with?("No match for")
      flash[:alert] = "No match"
    else
      flash[:danger] = "Lookup error, please try again"
    end

  end


  protected

  def configure_lookup_params
    params.permit(:lookup, :commit)
  end


end

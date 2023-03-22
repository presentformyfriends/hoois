class LookupController < ApplicationController
 
  before_action :configure_lookup_params

  require "whois-parser"


  def new
    @lookup = Lookup.new
  end

  def create

    clean_lookup = Lookup.call(params.permit(:lookup))

    # Run Whois lookup and return the formatted lookup and the result of the lookup
    if clean_lookup.present?

      puts "We have a clean lookup!"
          
      begin
          
        # Run Whois lookup, store content of response in var
        whois = Whois::Client.new
        response = whois.lookup(clean_lookup)
        result = response.content

      rescue Whois::ServerNotFound, Whois::NoInterfaceError, Whois::AllocationUnknown, Whois::ConnectionError, Timeout::Error
      
        # Lookup rescued by WhoisError, redirect to homepage, bypass render of show template
        redirect_to(homepage_path) and return
        # flash.now[:alert] = "Incomplete lookup, please try again"
        flash.now[:alert] = "Lookup scuffed, please try again"
        
      end

    else

      # Invalid lookup, redirect to homepage, bypass render of show template
      redirect_to(homepage_path) and return
      flash.now[:alert] = "Invalid lookup, please try again"

    end

    if result.present?
              
      # Render show with success if result is not nil and does NOT start with "No match for"
      # If result is not nil and DOES start with "No match for", render show with alert, otherwise render show with warning
      if (!result.nil? && !result.start_with?("No match for"))
        
        flash.now[:success] = "Lookup successful"

        @resultHeading = clean_lookup

        # Make all hyperlinks clickable in Whois record
        @result = result.gsub(/https?:\/\/.*/, '<a href="\0">\0</a>').html_safe

      elsif result.start_with?("No match for")

        flash.now[:alert] = "Lookup failed, record not found"
        @resultHeading = "No match for #{clean_lookup}"

      else

        flash.now[:warning] = "Lookup error, please try again"
        @resultHeading = "No match"

      end

      # Render show template
      render 'show'
    
    else

      flash.now[:alert] = "Lookup failed, invalid lookup"
      @resultHeading = "No match"

      # Result not present, redirect to homepage
      redirect_to homepage_path

    end

  end

  
  private

    def configure_lookup_params
      params.permit(:lookup)
    end
  
  
  end
  
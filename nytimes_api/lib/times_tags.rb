module NYTimes
  
  require 'commons'

  # The TimesTags service can help you build a tag set, standardize names of 
  # people and organizations, or identify subjects that are currently making news. 
  # Information architects and librarians may also wish to compare Times tags to 
  # Library of Congress subject headings and other classification systems.
  # 
  # Document page: http://developer.nytimes.com/docs/timestags_api
  #
  # Common parameters: version, api-key, response-format
  # Optional parameters: check the documentation (http://developer.nytimes.com/docs/timestags_api)
  # Check how to use parameters in: timestags_test
  #  
  class TimesTags < NYTimes::Commons
    
    require 'net/http'
    require 'rexml/document'

    # Boss URL base
    BASE_URL = "http://api.nytimes.com/svc/timestags/suggest"
  
    @@des = "(Des)"
    def des; return @@des; end
    
    @@Ggeo = "(Geo)"
    def geo; return @@geo; end
    
    @@org = "(Org)"
    def org; return @@org; end
    
    @@per = "(Per)"
    def per; return @@per; end
    
    
  
    # Random Comments
    # To retrieve a random set of user comments
    #
    # Filter:
    #   (Des) = Descriptive subject terms assigned by Times indexers (subject headings)
    #   (Geo) = Geographic locations
    #   (Org) = Organizations (includes companies)
    #   (Per) = People (persons)
    def suggest(query, par = {})
            
      url_temp = "#{BASE_URL}"
      
      parameters = Hash.new
      parameters.merge!(par) unless par.nil?
      parameters[:query] = query
      
      add = Hash.new
      add["api-key"] = timestags_key
      
      url = SomeAPI::Common.parse_url({:param => parameters, 
                                       :url => url_temp,
                                       :add => add})

      return process_return(url)
    end


   private 
      
   # Process the url and handle XML returned by the nytimes service.
   # For Times Tags service
   #
   def process_return url
     data = Net::HTTP.get_response(URI.parse(url)).body

     # header...
     header = Hash.new  
     header[:url] = url  

     return data, header
   end
   
   
    
  end
end
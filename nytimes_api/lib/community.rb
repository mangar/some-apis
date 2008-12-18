module NYTimes
  
  require 'commons'

  # Make a search on NYTimes Community.
  # Check the tests suit for samples of how to use it.
  # Spend some time to check the API document to 
  # see how to improve your search criteria.
  # 
  # Document page: http://developer.nytimes.com/docs/community_api
  #
  # Common parameters: version, api-key, response-format
  # Optional parameters: check the documentation (http://developer.nytimes.com/docs/community_api)
  # Check how to use parameters in: community_test
  #  
  class Community < NYTimes::Commons
    
    require 'net/http'
    require 'rexml/document'

    # Boss URL base
    BASE_URL = "http://api.nytimes.com/svc/community/"
  
    # API version
    VERSION = "v2/"
  
    # Random Comments
    # To retrieve a random set of user comments
    def random(par = {})
      url_temp = "#{BASE_URL}#{VERSION}/comments/random.#{format_default(par)}"
      
      parameters = Hash.new
      parameters.merge!(par)
      
      add = Hash.new
      add["api-key"] = community_key
      
      url = SomeAPI::Common.parse_url({:param => parameters, 
                                       :url => url_temp,
                                       :add => add,
                                       :remove => [:format]})

      return process_return(url, format_default(par))
    end

    # Recent Comments
    # To retrieve the most recent user comments
    def recent(par = {})
      url_temp = "#{BASE_URL}#{VERSION}/comments/recent.#{format_default(par)}"
      
      parameters = Hash.new
      parameters.merge!(par)
      
      translate = Hash.new
      translate[:force_replies] = "force-replies"

      add = Hash.new
      add["api-key"] = community_key
      
      url = SomeAPI::Common.parse_url({:param => parameters, 
                                       :url => url_temp,
                                       :add => add,
                                       :key_param_translation => translate,
                                       :remove => [:format]})

      return process_return(url, format_default(par))
    end

    # Comments by Date
    # To retrieve comments posted on a specific date    
    def by_date(date, par = {})
      url_temp = "#{BASE_URL}#{VERSION}/comments/by-date/#{date}.#{format_default(par)}"
      
      parameters = Hash.new
      parameters.merge!(par)
      
      add = Hash.new
      add["api-key"] = community_key
      
      url = SomeAPI::Common.parse_url({:param => parameters, 
                                       :url => url_temp,
                                       :add => add,
                                       :remove => [:format]})

      return process_return(url, format_default(par))
    end

    # Comments by User ID
    # To retrieve comments by a specific NYTimes.com use    
    def by_user(user_id, par = {})
      url_temp = "#{BASE_URL}#{VERSION}/comments/user/id/#{user_id}.#{format_default(par)}"
      
      parameters = Hash.new
      parameters.merge!(par)
      
      add = Hash.new
      add["api-key"] = community_key
      
      url = SomeAPI::Common.parse_url({:param => parameters, 
                                       :url => url_temp,
                                       :add => add,
                                       :remove => [:format]})

      return process_return(url, format_default(par))
    end

    # Comments by URL
    # To retrieve comments associated with a specific NYTimes.com URL    
    def by_url(match_type, url, par = {})
      url_temp = "#{BASE_URL}#{VERSION}/comments/url/#{match_type}.#{format_default(par)}"
      
      parameters = Hash.new
      parameters.merge!(par) unless (par.nil?)
      parameters[:url] = url
      
      add = Hash.new
      add["api-key"] = community_key
      
      url = SomeAPI::Common.parse_url({:param => parameters, 
                                       :url => url_temp,
                                       :add => add,
                                       :remove => [:format]})

      return process_return(url, format_default(par))      
    end
    


   
   
   private 
      
   # Process the url and handle XML returned by the nytimes service.
   # For community service
   #
   def process_return url, format
     data = Net::HTTP.get_response(URI.parse(url)).body

     # header...
     header = Hash.new  
     header[:url] = url  

     if (format == "xml") then
       doc = REXML::Document.new(data)
           
       header[:status] = doc.root.elements["status"].text
       header[:copyright] = doc.root.elements["copyright"].text
       header[:num_results] = doc.root.elements["results/totalCommentsReturned"].text if (doc.root.elements["results/totalCommentsReturned"] != nil)
         
       # data...
       records = Array.new
       doc.root.each_element('//result_set/results/comments/comment') do |review| 
         record = Hash.new     
         review.each_element do |ele|
           record.merge!({ele.name => ele.text})
         end
         records << record
       end    
     
       return records, header
       
     else
       return data, header
     end
     
   end
   
   
    
  end
end
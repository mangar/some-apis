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
  

    def random(par = {})
      
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
    
    def comments_by_date in_date
    end
    
    def comments_by_user in_userid
    end
    
    def comments_by_url in_url
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
       header[:num_results] = doc.root.elements["results/totalCommentsReturned"].text
         
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
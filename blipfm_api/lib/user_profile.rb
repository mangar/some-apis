module Blipfm
    
  # Call to getUserProfile API on Blip.fm
  # for more information point your browser to: http://api.blip.fm
  class UserProfile
    
    require 'net/http'
    require 'rexml/document'    
    
    # default quantity of musics to be displayed
    DEFAULT_LIMIT = "10"
    
    # default return format
    FORMAT_DEFAULT = "xml"
    
    #
    #
    def user_profile (username, par = {})
      
      limit = ((par.nil? || !par.key?(:limit)) ? DEFAULT_LIMIT : par[:limit]) 
      format = ((par.nil? || !par.key?(:format)) ? FORMAT_DEFAULT : par[:format])

      url_temp = "http://api.blip.fm/blip/getUserProfile.#{format}"
      
      parameters = Hash.new
      parameters.merge!(par)
      parameters[:username] = username
      parameters[:limit] = limit
      
      url = SomeAPI::Common.parse_url({:param => parameters, 
                                       :url => url_temp,
                                       :remove => [:format]})

      data = Net::HTTP.get_response(URI.parse(url)).body

      # header data...
      header = Hash.new  
      header[:url] = url  
      
      if (format == "xml") then
        
        doc = REXML::Document.new(data)
      
        header[:status_code] = doc.root.elements["status/code"].text
        header[:status_message] = doc.root.elements["status/message"].text
        header[:status_requestTime] = doc.root.elements["status/requestTime"].text
        header[:status_responseTime] = doc.root.elements["status/responseTime"].text
        header[:status_rateLimit] = doc.root.elements["status/rateLimit"].text
        header[:result_total] = doc.root.elements["result/total"].text
        header[:result_offset] = doc.root.elements["result/offset"].text
        header[:result_limit] = doc.root.elements["result/limit"].text
        header[:result_count] = doc.root.elements["result/count"].text

        # the result of the search..
        records = Array.new
        doc.root.each_element('//BlipApiResponse/result/collection/Blip') do |blip| 
          record = Hash.new     
          blip.each_element do |ele|
            record.merge!({ele.name => ele.text})
          end
          records << record
        end    
      
      else
        records = data
      end
      
      return records, header      
      
    end
    
  end
  
  
end
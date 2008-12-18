module NYTimes

  require 'commons'

  class MovieReviews < NYTimes::Commons

    require 'net/http'
    require 'rexml/document'
    require 'yaml'

    # Boss URL base
    BASE_URL = "http://api.nytimes.com/svc/movies/"
  
    # API version
    VERSION = "v2/"
  
    # Make a search on NYTimes Moview reviews.
    # Check the tests suit for samples of how to use it.
    # Spend some time to check the API document to 
    # see how to improve your search criteria.
    # 
    # Document page: http://developer.nytimes.com/docs/movie_reviews_api
    #
    # Common parameters: version, api-key, response-format
    # Optional parameters: check the documentation (http://developer.nytimes.com/docs/movie_reviews_api)
    # Check how to use parameters in: moview_reviews_test
    #
    def search(par = {})

      format = (par.key?(:format) ? par[:format] : FORMAT_DEFAULT)

      url_temp = "#{BASE_URL}#{VERSION}/reviews/search.#{format}"
      
      parameters = Hash.new
      parameters.merge!(par)
      
      translate = Hash.new
      translate[:thousand_best] = "thousand-best"
      translate[:critics_pick] = "critics-pick"
      translate[:publication_date] = "publication-date"
      translate[:opening_date] = "opening-date"

      add = Hash.new
      add["api-key"] = movie_reviews_key

      url = SomeAPI::Common.parse_url({:param => parameters, 
                                       :url => url_temp,
                                       :add => add,
                                       :key_param_translation => translate,
                                       :remove => [:format]})

      data = Net::HTTP.get_response(URI.parse(url)).body

      header = Hash.new  
      header[:url] = url  

      if (format == "xml") then

        doc = REXML::Document.new(data)

        # header...
        header[:status] = doc.root.elements["status"].text
        header[:copyright] = doc.root.elements["copyright"].text
        header[:num_results] = doc.root.elements["num_results"].text

        # data...
        records = Array.new
        doc.root.each_element('//result_set/results/review') do |review| 
          record = Hash.new     
          record["nyt_movie_id"] = review.attributes['nyt_movie_id']
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
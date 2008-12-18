module NYTimes
  class Commons

    require 'yaml'    

    attr_reader :errors
    
        
    # Default response format (xml / json)
    # Can be replaced via parameter
    FORMAT_DEFAULT = "xml"


    def format_default par
      return (par.nil? ? FORMAT_DEFAULT : (par.key?(:format) ? par[:format] : FORMAT_DEFAULT))
    end


    def movie_reviews_key
      config = YAML.load_file(File.dirname(__FILE__) + "/nytimes.yml")['api_key']
      return config['movie_reviews']
    end
    
    def community_key
      config = YAML.load_file(File.dirname(__FILE__) + "/nytimes.yml")['api_key']
      return config['community']
    end


    def add_error message
      @errors = String.new if @errors.nil?
      @errors += " - #{message};"
    end
    
  end
end
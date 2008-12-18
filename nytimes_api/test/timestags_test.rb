require 'test/unit'

require 'yaml'
require 'cgi'
require '../../lib/nytimes_api'
require '../lib/commons'

class TimetagsTest < Test::Unit::TestCase

  def setup
    commons = NYTimes::Commons.new
    @api_key = CGI::escape(commons.timestags_key)
  end

  def test_sugest
  
    tags = NYTimes::TimesTags.new
    query = "Steve Jobs"
  
    #Simple recent call on json format
    records, header = tags.suggest(query)
    assert_equal("http://api.nytimes.com/svc/timestags/suggest?api-key=#{@api_key}&query=Steve+Jobs", "#{header[:url]}", "Invalid URL!")
    assert_equal(String, records.class, "Content return for JSON must be a String")

    # Test with filter    
    #   (Des) = Descriptive subject terms assigned by Times indexers (subject headings)
    #   (Geo) = Geographic locations
    #   (Org) = Organizations (includes companies)
    #   (Per) = People (persons)
    records, header = tags.suggest(query, {:filter => "#{tags.des},#{tags.org}"})
    assert_equal("http://api.nytimes.com/svc/timestags/suggest?api-key=#{@api_key}&filter=%28Des%29%2C%28Org%29&query=Steve+Jobs", "#{header[:url]}", "Invalid URL!")
    assert_equal(String, records.class, "Content return for JSON must be a String")

  end


end
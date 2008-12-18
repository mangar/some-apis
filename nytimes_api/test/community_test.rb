require 'test/unit'

require 'yaml'
require 'cgi'
require '../../lib/nytimes_api'
require '../lib/commons'

class ComunityTest < Test::Unit::TestCase

  def setup
    commons = NYTimes::Commons.new
    @api_key = CGI::escape(commons.community_key)
  end


  def test_recent

    com = NYTimes::Community.new

    #Simple recent call on json format
    records, header = com.recent({:format => "json"})
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/recent.json?api-key=#{@api_key}", "#{header[:url]}", "Invalid URL!")
    assert_equal(String, records.class, "Content return for JSON must be a String")
    
    #Simple recent call
    records, header = com.recent
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/recent.xml?api-key=#{@api_key}", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")

    #Specific offset (starting from XX record..)
    records, header = com.recent({:offset => "25"})
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/recent.xml?api-key=#{@api_key}&offset=25", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")

    #force_replies
    records, header = com.recent({:force_replies => "0"})
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/recent.xml?api-key=#{@api_key}&force-replies=0", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")

  end

  def test_random
    
  end


end

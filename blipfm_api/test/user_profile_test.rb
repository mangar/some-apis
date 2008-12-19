require 'test/unit'

require 'yaml'
require 'cgi'
require '../../lib/blipfm_api'

class UserProfileTest < Test::Unit::TestCase

  def setup
    
  end


  def test_user_profile

    blip = Blipfm::UserProfile.new

    username = "marciogarcia"
  
    #Simple call on json format
    records, header = blip.user_profile(username, {:format => "json"})
    assert_equal("http://api.blip.fm/blip/getUserProfile.json?limit=10&username=#{username}", "#{header[:url]}", "Invalid URL!")
    assert_equal(String, records.class, "Content return for JSON must be a String")
    
    # #Simple call
    records, header = blip.user_profile(username)
    assert_equal("http://api.blip.fm/blip/getUserProfile.xml?limit=10&username=#{username}", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
    assert_equal(10, records.size, "Ask for default limit of records: 10")

    #Simple call with offset
    records, header = blip.user_profile(username, {:limit => "20"})
    assert_equal("http://api.blip.fm/blip/getUserProfile.xml?limit=20&username=#{username}", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
    assert_equal(20, records.size, "Asked for 20 records...")
    
    #Simple call with offset
    records, header = blip.user_profile(username, {:limit => "20", :offset => "25"})
    assert_equal("http://api.blip.fm/blip/getUserProfile.xml?limit=20&offset=25&&username=#{username}", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
    assert_equal(20, records.size, "Asked for 20 records...")    
    
    
    assert(header[:status_message], ":status_message field is missing")
    assert(header[:result_limit], ":result_limit field is missing")
    assert(header[:status_requestTime], ":status_requestTime field is missing")
    assert(header[:result_count], ":result_count field is missing")
    assert(header[:status_responseTime], ":status_responseTime field is missing")
    assert(header[:url], ":url field is missing")
    assert(header[:status_rateLimit], ":status_rateLimit field is missing")
    assert(header[:status_code], ":status_code field is missing")
    assert(header[:result_total], ":result_total field is missing")
    assert(header[:result_offset], ":result_offset field is missing")
        
  
    puts "#{header.inspect}"
    
  end

end

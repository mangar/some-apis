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
    
    record = records[0]    
    assert(record.key?("replies"), "Replies field is not in")
    assert(record.key?("userComments"), "userComments field is not in")
    assert(record.key?("commentBody"), "commentBody field is not in")
    assert(record.key?("userTitle"), "userTitle field is not in")
    assert(record.key?("articleURL"), "articleURL field is not in")
    assert(record.key?("commentTitle"), "commentTitle field is not in")
    assert(record.key?("display_name"), "display_name field is not in")
    assert(record.key?("userURL"), "userURL field is not in")
    assert(record.key?("recommendations"), "recommendations field is not in")
    # assert(record.key?("commentQuestion"), "commentQuestion field is not in")
    assert(record.key?("approveDate"), "approveDate field is not in")
    assert(record.key?("location"), "location field is not in")
    
    
  
  end
  
  def test_random
    
    com = NYTimes::Community.new
  
    #Simple recent call on json format
    records, header = com.random({:format => "json"})
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/random.json?api-key=#{@api_key}", "#{header[:url]}", "Invalid URL!")
    assert_equal(String, records.class, "Content return for JSON must be a String")
    
    #Simple recent call
    records, header = com.random
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/random.xml?api-key=#{@api_key}", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
    assert_equal(25, records.size, "I asked for 30 records.")
    
    #Specific offset (starting from XX record..)
    records, header = com.random({:count => "30"})
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/random.xml?api-key=#{@api_key}&count=30", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
    assert_equal(30, records.size, "I asked for 30 records.")
    
    record = records[0]    
    assert(record.key?("replies"), "Replies field is not in")
    assert(record.key?("userComments"), "userComments field is not in")
    assert(record.key?("commentBody"), "commentBody field is not in")
    assert(record.key?("userTitle"), "userTitle field is not in")
    assert(record.key?("articleURL"), "articleURL field is not in")
    assert(record.key?("commentTitle"), "commentTitle field is not in")
    assert(record.key?("display_name"), "display_name field is not in")
    assert(record.key?("userURL"), "userURL field is not in")
    assert(record.key?("recommendations"), "recommendations field is not in")
    # assert(record.key?("commentQuestion"), "commentQuestion field is not in")
    assert(record.key?("approveDate"), "approveDate field is not in")
    assert(record.key?("location"), "location field is not in")
        
  end


  def test_bydate
    
    com = NYTimes::Community.new
    date = "20081210"
  
    #Simple call on json format
    records, header = com.by_date(date, {:format => "json"})
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/by-date/#{date}.json?api-key=#{@api_key}", "#{header[:url]}", "Invalid URL!")
    assert_equal(String, records.class, "Content return for JSON must be a String")
    
    #Simple call
    records, header = com.by_date(date)
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/by-date/#{date}.xml?api-key=#{@api_key}", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
    assert_equal(25, records.size, "I asked for 25(default \#) records.")
  
    #Simple call with offset parameter
    records, header = com.by_date(date, {:offset => "25"})
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/by-date/#{date}.xml?api-key=#{@api_key}&offset=25", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
    assert_equal(25, records.size, "I asked for 25(default \#) records.")
  
    record = records[0]    

    # puts "Record: \n #{record.inspect}"
    # d = Date.new(record["approveDate"])
    # puts "Date: #{d}"
    
    assert(record.key?("replies"), "Replies field is not in")
    assert(record.key?("userComments"), "userComments field is not in")
    assert(record.key?("commentBody"), "commentBody field is not in")
    assert(record.key?("userTitle"), "userTitle field is not in")
    assert(record.key?("articleURL"), "articleURL field is not in")
    assert(record.key?("commentTitle"), "commentTitle field is not in")
    assert(record.key?("display_name"), "display_name field is not in")
    assert(record.key?("userURL"), "userURL field is not in")
    assert(record.key?("recommendations"), "recommendations field is not in")
    # assert(record.key?("commentQuestion"), "commentQuestion field is not in")
    assert(record.key?("approveDate"), "approveDate field is not in")
    assert(record.key?("location"), "location field is not in")
        
  end


  def test_bydate
    
    com = NYTimes::Community.new
    user_id = "20081210"
  
    #Simple call on json format
    records, header = com.by_user(user_id, {:format => "json"})
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/user/id/#{user_id}.json?api-key=#{@api_key}", "#{header[:url]}", "Invalid URL!")
    assert_equal(String, records.class, "Content return for JSON must be a String")
    
    #Simple call
    records, header = com.by_user(user_id)
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/user/id/#{user_id}.xml?api-key=#{@api_key}", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
  
    
    #Simple call with offset parameter
    records, header = com.by_user(user_id, {:offset => "25"})
    assert_equal("http://api.nytimes.com/svc/community/v2//comments/user/id/#{user_id}.xml?api-key=#{@api_key}&offset=25", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
        
  end




end

require 'test/unit'
require '../../lib/common_api'

class CommonTest < Test::Unit::TestCase

  def test_parse_url

    parameters = Hash.new
    parameters["controller"] = "index_controller"
    parameters["action"] = "index"

    url = SomeAPI::Common.parse_url({:param => parameters})
    assert_equal("", url, "URL must ignore 'controller' and 'action' parameter as default")    

    parameters["key1"] = "value1"
    url = SomeAPI::Common.parse_url({:param => parameters})
    assert_equal("?key1=value1", url, "URL must have one key pair value!")    

    parameters["key2"] = "value 2"
    url = SomeAPI::Common.parse_url({:param => parameters})
    assert_equal("?key1=value1&key2=value+2", url, "URL must have two keys pair values and space escaped!")    
    

    url = SomeAPI::Common.parse_url({:param => parameters, :url => "http://api.site.com"})
    assert_equal("http://api.site.com?key1=value1&key2=value+2", url, "Where is the complete URL? Starting with http://....?")    


    url = SomeAPI::Common.parse_url({:param => parameters, 
                                     :url => "http://api.site.com",
                                     :add => {"fixed1" => "fixed value 1"} })
    assert_equal("http://api.site.com?fixed1=fixed+value+1&key1=value1&key2=value+2", url, "Where is the fixed value?")    


    url = SomeAPI::Common.parse_url({:param => parameters, 
                                     :url => "http://api.site.com",
                                     :add => {"fixed1" => "fixed value 1", "fixed2" => "fixed value 2"} })
    assert_equal("http://api.site.com?fixed1=fixed+value+1&fixed2=fixed+value+2&key1=value1&key2=value+2", url, "Where the second fixed value?")    

    
    url = SomeAPI::Common.parse_url({:param => parameters, 
                                     :url => "http://api.site.com",
                                     :add => {"fixed1" => "fixed value 1", "fixed2" => "fixed value 2"},
                                     :remove => ["fixed1", "fixed2", "key2"] })
    assert_equal("http://api.site.com?key1=value1", url, "Removing all parameters lefting just key1")    
    
    
    url = SomeAPI::Common.parse_url({:param => parameters, 
                                     :url => "http://api.site.com",
                                     :add => {"fixed1" => "fixed value 1", "fixed2" => "fixed value 2"},
                                     :remove => ["fixed1", "fixed2", "key2"],
                                     :key_param_translation => {"key1" => "KEY10"}})
    assert_equal("http://api.site.com?KEY10=value1", url, "Replacing 'key1' to 'KEY10'")    


    url = SomeAPI::Common.parse_url({:param => parameters, 
                                     :url => "http://api.site.com",
                                     :add => { :fixed1 => "fixed value 1"},
                                     :remove => ["key1", "key2"]})
    assert_equal("http://api.site.com?fixed1=fixed+value+1", url, "Testing with symbols")    

  end


  def test_order_hash
    common = SomeAPI::Common.new 

    h = Hash.new
    h["z"] = "0"
    h[:c] = "100"        
        
    k, h2 = common.order_hash h
    assert_equal("[\"c\", \"z\"]", k.inspect, "Not in right order (1)")
    assert_equal(true, has_just_string(h2.keys), "Hash keys not transformed to String (1)")
        

    h["a"] = "30"
    h[:b] = "2"
    
    k, h2 = common.order_hash h
    assert_equal("[\"a\", \"b\", \"c\", \"z\"]", k.inspect, "Not in right order (2)")
    assert_equal(true, has_just_string(h2.keys), "Hash keys not transformed to String (2)")    
    
    
    h["1"] = "2"
    h[:x] = "2"
    
    k, h2 = common.order_hash h
    assert_equal("[\"1\", \"a\", \"b\", \"c\", \"x\", \"z\"]", k.inspect, "Not in right order (3)")
    assert_equal(true, has_just_string(h2.keys), "Hash keys not transformed to String (3)")    

    # puts "#{a}"
    
  end

  def has_just_string array
    array.each do |k|
      return false unless k.class.eql? String
    end
    return true
  end


end

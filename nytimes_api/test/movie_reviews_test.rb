require 'test/unit'

require 'yaml'
require 'cgi'
require '../../lib/nytimes_api'
require '../lib/commons'

class MovieReviewsTest < Test::Unit::TestCase

  def setup
    commons = NYTimes::Commons.new
    @api_key = CGI::escape(commons.movie_reviews_key)
  end

  def test_search

    mr = NYTimes::MovieReviews.new

    #search movie reviews for "Matrix" and on json format
    content, header = mr.search({:query => "matrix", :format => "json"})
    assert_equal("http://api.nytimes.com/svc/movies/v2//reviews/search.json?api-key=#{@api_key}&query=matrix", "#{header[:url]}", "Invalid URL!")
    assert_equal(String, content.class, "Content return for JSON must be a String")


    #search movie reviews for "Matrix"....
    #query: Search keywords; matches movie title and indexed terms
    records, header = mr.search({:query => "matrix"})
    assert_equal("http://api.nytimes.com/svc/movies/v2//reviews/search.xml?api-key=#{@api_key}&query=matrix", "#{header[:url]}", "Invalid URL!")    
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")

    
    #search moview reviews: Matrix ordered by title...
    #order: Sets the sort order of the results
    records, header = mr.search({:query => "matrix", :order => "by-title"})    
    assert_equal("http://api.nytimes.com/svc/movies/v2//reviews/search.xml?api-key=#{@api_key}&order=by-title&query=matrix", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
    
    #Set this parameter to Y to limit the results to movies on the Times list of The Best 1,000 Movies Ever Made.
    # thousand-best: Limits by Best 1,000 Movies status
    #Are Keanu Reeves in the top 1000 movies list of Times?
    records, header = mr.search({:query => "keanu reeves", :order => "by-title", :thousand_best => "Y"})      
    assert_equal("http://api.nytimes.com/svc/movies/v2//reviews/search.xml?api-key=#{@api_key}&order=by-title&query=keanu+reeves&thousand-best=Y", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
        
    #Set this parameter to Y to limt the results to NYT Critics' Picks. To get only those movies that have not been 
    # highlighted by Times critics, specify critics-pick=N. (To get all reviews regardless of critics-pick status, 
    # simply omit this parameter.)
    #critics-pick: Limits by NYT Critics' Picks status
    records, header = mr.search({:query => "keanu reeves", :order => "by-title", :critics_pick => "Y"})      
    assert_equal("http://api.nytimes.com/svc/movies/v2//reviews/search.xml?api-key=#{@api_key}&critics-pick=Y&order=by-title&query=keanu+reeves", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
    
    # Set this parameter to Y to limit the results to movies that have been released on DVD
    #dvd: 
    records, header = mr.search({:query => "keanu reeves", :order => "by-title", :dvd => "Y"})      
    assert_equal("http://api.nytimes.com/svc/movies/v2//reviews/search.xml?api-key=#{@api_key}&dvd=Y&order=by-title&query=keanu+reeves", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
        
    # The publication-date is the date the review was first published in The Times.
    # publication-date: Single date: YYYY-MM-DD    or    Start and end date: YYYY-MM-DD;YYYY-MM-DD
    records, header = mr.search({:query => "nicole kidman", :order => "by-title", :publication_date => "2000-01-01;2008-11-30"})      
    assert_equal("http://api.nytimes.com/svc/movies/v2//reviews/search.xml?api-key=#{@api_key}&order=by-title&publication-date=2000-01-01%3B2008-11-30&query=nicole+kidman", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
        
    # The opening-date is the date the movie's opening date in the New York region.
    # opening-date Single date: YYYY-MM-DD    or    Start and end date: YYYY-MM-DD;YYYY-MM-DD
    records, header = mr.search({:query => "Nicole Kidman", :order => "by-title", :opening_date => "2008-01-01;2008-11-30"})          
    assert_equal("http://api.nytimes.com/svc/movies/v2//reviews/search.xml?api-key=#{@api_key}&opening-date=2008-01-01%3B2008-11-30&order=by-title&query=Nicole+Kidman", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")
    
    # Positive integer, multiple of 20
    # The first 20 results are shown by default. To page through the results, set offset to the appropriate value (e.g., offset=20 displays results 21–40).
    # offset: Sets the starting point of the result set
    records, header = mr.search({:query => "Nicole Kidman", :order => "by-title", :offset => "40"})          
    assert_equal("http://api.nytimes.com/svc/movies/v2//reviews/search.xml?api-key=#{@api_key}&offset=40&order=by-title&query=Nicole+Kidman", "#{header[:url]}", "Invalid URL!")
    assert_equal(Array, records.class, "Content return for XML(default) must be an Array")

    # puts "..:: HEADER ::.. \n"
    # header.each_pair { |k,v|  puts "#{k} => #{v}" } 
    # puts "..:: RECORDS ::.. \n"
    # records.each { |v|  puts "#{v.entries}" } 

  end

end

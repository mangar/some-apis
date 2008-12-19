#Some APIs

This is a helper to get access to _Some APIs_ that I've found around the Internet.

This is using Ruby on Rails.

##New York Times

To use it, you have to get an api-key in NYTimes website: [http://developer.nytimes.com/apps/register](http://developer.nytimes.com/apps/register "http://developer.nytimes.com/apps/register")

Get your API-Key and past it into .yml file for specific API that you have intention to use.

###Movie Review

	require 'nytimes_api'
	#.
	mr = NYTimes::MovieReviews.new
    content, header = mr.search({:query => "matrix"})

###Time Tags

	require 'nytimes_api'
	#.
    tags = NYTimes::TimesTags.new
    records, header = tags.suggest("Steve Jobs")

###Community

	require 'nytimes_api'
	#.
	com = NYTimes::Community.new
	records, header = com.recent

##Blip.fm

###User Profile

	require 'blipfm_api'
	#.
	blip = Blipfm::UserProfile.new
	records, header = blip.user_profile("marciogarcia")

##Yahoo!

###Boss

_*Soon / Roadmap..._


###FlickR

_*Soon / Roadmap..._


###Delicious

_*Soon / Roadmap..._


###Help

If you know more useful websites with API access and want to let this APIs easiest to integrate on RoR projects, join us! Make a fork and implement your!


Copyright (c) 2008 [Marcio Garcia](http://marciogarcia.com "http://marciogarcia.com"), released under the MIT license
# NYTimesApi

This is a helper to get access to New York Times API using Ruby on Rails.

To use it, you have to get an api-key in NYTimes website: [http://developer.nytimes.com/apps/register](http://developer.nytimes.com/apps/register "http://developer.nytimes.com/apps/register")

Get your API-Key and past it into .yaml file for specific API that you have intention to use (movie\_reviews for example: movie_reviews.yaml)

## Example

### Movie Review

This sample look for reviews for "Matrix": 

	require 'nytimes_api'
	#.
	#.
    records, header = NYTimes::MovieReviews.search({:query => "matrix"})

More samples can be found on test directory.


### Time Tags

_*Soon..._


### Community

_*Soon..._


### Campaign Finance

_*Soon..._


Copyright (c) 2008 [Marcio Garcia](http://marciogarcia.com "http://marciogarcia.com"), released under the MIT license
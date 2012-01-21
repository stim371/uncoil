# uncoil - the link unshortening gem

The uncoil gem is a one stop shop for un-shortening urls.

The idea is based off of my site http://uncoil.me and I built this as part of my UWE-Ruby fall project.

## Why the heck does this exist?
This gem is all about transparency, safety and knowing where you are going on the internet.

The last straw was seeing TechCrunch articles with titles like "Don't click on this one specific goo.gl link! It's a virus!" (like [this](http://techcrunch.com/2010/12/07/twitter-virus/) one), which was flabbergasting. How is it that a tech blog and community's only response to these kind of threats is so reactionary and linear? **We can do better than that.**

There are a few instances where it may come in handy:

* You want to make sure you're not heading into an obviously sketchy site
* You're at work and want to keep out the NSFW

## Installation

Install the gem:

    gem install uncoil

Add it to your file:

```ruby
require 'uncoil'
```

## Usage
* If you have Bitly login credentials, use them to create a new instance:

```ruby
@a = Bitly.new(:bitlyuser => 'YOURAPIUSERNAME', :bitlykey => 'YOURAPIKEY')
# Or if you don't have any auth criteria
@a = Bitly.new
# in which case it will use a standard HTTP loop to find bitly destination urls
```

* Use the  `expand` method to see where the short link goes:

```ruby
@a.expand('http://bit.ly/2EEjBl')
# or pass in an array of links
@a.expand(['http://bit.ly/2EEjBl','http://is.gd/gbKNRq'])
```

For each link you pass in, you will get a separate `Uncoil::Response` object out with parameters for `long_url`, `short_url` and `error`

A full usage cycle may look like this:

```ruby
@a = Bitly.new(:bitlyuser => 'YOURAPIUSERNAME', :bitlykey => 'YOURAPIKEY')
@b = @a.expand('http://bit.ly/2EEjBl') # => <Uncoil::Response:0x00000100a0d948 @long_url="http://www.cnn.com/" @short_url="http://bit.ly/2EEjBl" @error=nil>

@b.long_url   # => "http://www.cnn.com/"
@b.short_url  # => "http://bit.ly/2EEjBl"
@b.error      # => nil
```

## How the app works

1. Extract the domain from the url
2. See if it matches with any of the supported APIs
  * If so, it calls the correct API method
  * If no matching method is found, it runs through an HTTP loop until it receives a 200 response
3. It then returns a hash containing, among other items, the full url

## Future Enhancements
Here are a few ideas I have for the future:

* Additional APIs as they become available
  * These seem to be faster than a general HTTP request loop
* Modularized structure with each API's content in its own file
* Dynamic method assignment based on domain.  
  * This goes with the modularized structure above, because it allows you to just drop more API files into the folder and not have to modify the main method
* Better error handling (I'd appreciate any comments on what to catch and what to leave)

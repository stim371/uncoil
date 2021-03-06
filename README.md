# uncoil - the link unshortening gem

[![Build Status](https://secure.travis-ci.org/stim371/uncoil.png)](http://travis-ci.org/stim371/uncoil)

The uncoil gem is a one stop shop for un-shortening urls.

I built this as part of my UWE-Ruby fall project.

### Why the heck does this exist?
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

### One-off Calls
If you want to just make a single call, give this a try:

```ruby
Uncoil.expand('http://bit.ly/2EEjBl') # => <Uncoil::Response:0x00000100a0d948 @long_url="http://www.cnn.com/" @short_url="http://bit.ly/2EEjBl" @error=nil>
```

### Creating an Instance
If you need to make repeated calls or would like to access the bitly api, you need to create an instance.

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
3. It then returns a Response object containing, among other items, the full url

## Future Enhancements
Here are a few ideas I have for the future:

* Additional APIs as they become available
  * These seem to be faster than a general HTTP request loop
* Modularized structure with each API's content in its own file
* Dynamic method assignment based on domain.  
  * This goes with the modularized structure above, because it allows you to just drop more API files into the folder and not have to modify the main method
* Better error handling (I'd appreciate any comments on what to catch and what to leave)

## License

The MIT License (MIT)

Copyright (c) 2012 Joel Stimson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

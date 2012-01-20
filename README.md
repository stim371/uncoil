# uncoil

The uncoil gem is a one stop shop for un-shortening urls.

The idea is based off of my site http://uncoil.me and I built this as part of my UWE-Ruby fall project.

## Why the heck does this exist?
This gem is all about transparency and safety, and knowing where you are going on the internet.

There are a few instances where it may come in handy:

* You want to make sure you're not heading into an obviously sketchy site
* You're at work and want to keep out the NSFW

## Example
I have no idea where http://bit.ly/2EEjBl really goes.

But by expanding it with uncoil, I can see that it goes to http://www.cnn.com

## How the app works

1. Extract the domain from the url
2. See if it matches with any of the supported APIs
  * If so, it calls the correct API method
  * If no matching method is found, it runs through an HTTP loop until it receives a 200 response
3. It then returns a hash containing, among other items, the full url

## Current Issues

## Future Enhancements
Here are a few ideas I have for the future:

* Additional APIs as they become available
  * These seem to be faster than a general HTTP request loop
* Modularized structure with each API's content in its own file
* Dynamic method assignment based on domain.  
  * This goes with the modularized structure above, because it allows you to just drop more API files into the folder and not have to modify the main method
* Better error handling (I'd appreciate any comments on what to catch and what to leave)

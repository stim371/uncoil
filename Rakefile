require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('uncoil', '0.1.0') do |p|
  p.description     = "Expand shortened links to their true url."
  p.url             = "http://github.com/stim371/uncoil"
  p.author          = "Joel Stimson"
  p.email           = "contact@cleanroomstudios.com"
  p.ignore_pattern  = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
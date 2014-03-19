$:.push File.expand_path("../lib", __FILE__)

require "will_translate/version"

Gem::Specification.new do |s|
  s.name          = "will_translate"
  s.version       = WillTranslate::VERSION
  
  s.author        = "Jon Pearse"
  s.email         = "jon@jonpearse.net"
  s.description   = "Yet another gem to allow easy translation of Model fields"
  s.summary       = "will_translate is yet another RoR gem that hopefully makes translation of Model fields painfully easy"
  s.homepage      = "http://github.com/jonpearse/will_translate"
  
  s.files         = Dir["lib/**/*"]
  s.require_paths = ["lib"]
end
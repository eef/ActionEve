require 'rubygems'

SPEC = Gem::Specification.new do |s|
  s.name             = "action_eve"
  s.version          = "0.1"
  s.homepage         = "http://actioneve.evecert.com/"
  s.author           = "Arthur Canal"
  s.email            = "arthur.canal@gmail.com"
  s.platform         = Gem::Platform::RUBY
  s.summary          = "Eve Online library for Ruby on Rails"
  s.files            = Dir.glob("{bin, docs, lib, test}/**/*").delete_if do |item|
                         item.include?("CVS") || item.include?("rdoc")
                       end
  s.require_path     = "lib"
  s.autorequire      = "action_eve"
end    

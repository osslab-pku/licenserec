#!/usr/bin/env ruby

require 'licenserec'
require 'licensecompatibility'

puts "这是一个简单的 Ruby 库"
puts Licenserec::CompatibilityFilter.new("E:\\ninka-tool\\ninka-master")


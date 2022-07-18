#!/usr/bin/env ruby

require 'licenserec'
require 'licensecompatibility'
require 'set'

puts "这是一个简单的 Ruby 库"

puts Licenserec::CompatibilityFilter.new("E:\\OSSLSelection\\OSSLSelection\\test\\license-test\\license_test","C:\\Strawberry\\perl\\bin\\ninka.pl","popular")

puts Licenserec::CompatibilityCheck.new("E:\\OSSLSelection\\OSSLSelection\\test\\license-test\\license_test","C:\\Strawberry\\perl\\bin\\ninka.pl")




#!/usr/bin/env ruby

require 'licenserec'
require 'licensecompatibility'
require 'licensesort'
require 'licensecompare'
require 'licensetypeguide'
require 'licensetermchoice'
require 'set'

puts "这是一个简单的 Ruby 库"

# puts Licenserec::CompatibilityFilter.new("E:\\OSSLSelection\\OSSLSelection\\test\\license-test\\license_test","C:\\Strawberry\\perl\\bin\\ninka.pl","popular")
#
# puts Licenserec::CompatibilityCheck.new("E:\\OSSLSelection\\OSSLSelection\\test\\license-test\\license_test","C:\\Strawberry\\perl\\bin\\ninka.pl")

sort_hash =  Licenserec::LicenseSort.csv_to_hash("lib\\license_readability.csv",header=true,0,4)
# puts Licenserec::LicenseSort.sortvalue_lookup("GPL-2.0",sort_hash)
puts Licenserec::LicenseSort.license_sort(["MIT","GPL-2.0","Apache-2.0"],desc=false, sort_hash)
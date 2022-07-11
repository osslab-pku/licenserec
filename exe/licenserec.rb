#!/usr/bin/env ruby

require 'licenserec'
require 'licensecompatibility'
require 'set'

puts "这是一个简单的 Ruby 库"

licenseA_set = Set.new
licenseA_set.add("Apache-2.0")
licenseB_list = ["Apache-2.0","GPL-2.0","GPL-3.0","MulanPSL-2.0","MPL-2.0"]
puts Licenserec::CompatibilityFilter.new("E:\\OSSLSelection\\OSSLSelection\\test\\license-test\\license_test",licenseA_set,licenseB_list)

puts Licenserec::CompatibilityCheck.new("E:\\OSSLSelection\\OSSLSelection\\test\\license-test\\license_test")

puts Licenserec::LicenseGuide.new(licenseB_list)


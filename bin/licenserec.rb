#!/usr/bin/env ruby

require 'licenserec'
require 'licensecompatibility'
require 'licensesort'
require 'licensecompare'
require 'licensetypeguide'
require 'licensetermchoice'
require 'set'

puts "这是一个简单的 Ruby 库"

# # licensecompatibility测试
# hh = Licenserec::CompatibilityFilter.compatibility_meaning()
# hh.each { |kk,vv| puts kk+'---'+vv }
# l1,l2 = Licenserec::CompatibilityFilter.license_detection("E:\\OSSLSelection\\OSSLSelection\\test\\license-test\\license_test","C:\\Strawberry\\perl\\bin\\ninka.pl")
# puts l1
# l2.each do |ii|
#   puts ii
# end
# puts Licenserec::CompatibilityFilter.compatibility_lookup('Apache-2.0','GPL-3.0')
# l1,l2,l3,_ = Licenserec::CompatibilityFilter.compatibility_filter("E:\\OSSLSelection\\OSSLSelection\\test\\license-master1","C:\\Strawberry\\perl\\bin\\ninka.pl","popular")
# puts "---------"
# puts l1.empty?
# puts l1
# puts l2.empty?
# puts l2
# puts l3.empty?
# puts l3
# puts Licenserec::CompatibilityCheck.compatibilitycheck("E:\\OSSLSelection\\OSSLSelection\\test\\license-test\\license_test","C:\\Strawberry\\perl\\bin\\ninka.pl")

# # licensetyoeguide测试
# hh = Licenserec::LicensetypeGuide.business_model_feature()
# hh.each { |kk,vv| puts kk + '----' + vv }


# # licensetermchoice测试
# hash_meaning = Licenserec::TermsChoice.important_terms_instruction()
# hash_meaning.each { |kk,vv| puts kk + "----" + vv }
# puts Licenserec::TermsChoice.license_term_lookup("GPL-3.0","copyleft")
# ll =  Licenserec::TermsChoice.license_term_choice("patent",['MIT','GPL-2.0'],1)
# ll.each { |l| puts l }
# puts ll.empty?

# # licensecompare测试
# hh = Licenserec::TermsCompare.licenses_term_compare(['MIT','Apache-2.0','MulanPSL-2.0','GPL-2.0','GPL-3.0'])
# hh.each { |kk,vv|
#   puts kk
#   puts vv[18].class
# }
# puts hh

# # licensesort测试
# sort_hash =  Licenserec::LicenseSort.csv_to_hash("lib\\license_readability.csv",header=true,0,4)
# puts Licenserec::LicenseSort.sortvalue_lookup("GPL-2.0",sort_hash)
# puts Licenserec::LicenseSort.license_sort(["MIT","GPL-2.0","Apache-2.0"],desc=false, sort_hash)
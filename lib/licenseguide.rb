# frozen_string_literal: true

require_relative "licenserec/version"
require 'set'
require 'csv'

module Licenserec
  class LicenseGuide
    def initialize()
      puts "许可证选择向导"
    end

    def self.license_term_lookup(one_license,one_term)
      term_feature = -1
      c_table = CSV.read("E:\\OSSLSelection\\OSSLSelection\\csv\\licenses_terms_63.csv",headers:true)
      CSV.foreach("E:\\OSSLSelection\\OSSLSelection\\csv\\licenses_terms_63.csv") do |row|
        if row[0] == one_license
          no_row = $.
          term_feature = c_table[no_row-2][term]
        end
      end
      return term_feature
    end

    def self.licenses_term_compare(licenses_list)
      license_terms_hash = Hash.new
      c_table = CSV.read("E:\\OSSLSelection\\OSSLSelection\\csv\\licenses_terms_63.csv",headers:true)
      CSV.foreach("E:\\OSSLSelection\\OSSLSelection\\csv\\licenses_terms_63.csv") do |row|
        licenses_list.each do |one_license|
          if row[0] == one_license
            no_row = $.
            license_terms_hash.store(one_license,c_table[no_row-2])
          end
        end
      end
      return license_terms_hash
    end

    def self.os_style_guide()
      puts ""
    end

    def self.os_business_guide()
      puts ""
    end

    def self.os_community_guide()
      puts ""
    end

  end

end

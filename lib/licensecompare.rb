# frozen_string_literal: true

require_relative "licenserec/version"
require 'csv'


module Licenserec
  class TermsCompare
    def initialize()

    end

    # 输入为许可证列表，输出列表中的许可证的条款要素值，
    def self.licenses_term_compare(licenses_list)
      license_terms_hash = Hash.new
      c_table = CSV.read("lib\\licenses_terms_63.csv",headers:true)
      CSV.foreach("lib\\licenses_terms_63.csv") do |row|
        licenses_list.each do |one_license|
          if row[0] == one_license
            no_row = $.
            license_terms_hash.store(one_license,c_table[no_row-2])
          end
        end
      end
      return license_terms_hash
    end

  end
end

# frozen_string_literal: true

require_relative "licenserec/version"
require 'csv'
require 'pathname'

module Licenserec
  class TermsCompare
    def initialize()

    end

    # 输入为许可证列表，输出列表中的许可证的条款要素值。
    def self.licenses_term_compare(licenses_list)
      license_terms_hash = Hash.new
      license_terms_hash.store("license",["info","preamble","define","copyright	patent",	"trademark",	"copyleft",	"interaction",	"modification",	"retain_attr",	"enhance_attr",	"acceptance",	"patent_term",	"vio_term",	"disclaimer",	"law",	"instruction",	"compatible_version",	"secondary_license",	"gpl_combine"])
      cur_path=String(Pathname.new(File.dirname(__FILE__)).realpath)
      c_table = CSV.read(cur_path+"\\licenses_terms_63.csv",headers:true)
      CSV.foreach(cur_path+"\\licenses_terms_63.csv") do |row|
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

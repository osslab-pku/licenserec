# frozen_string_literal: true

require_relative "licenserec/version"
require 'csv'


module Licenserec
    class License_sort
      def initialize()
      end
        
        def self.license_lookup(one_license,table,key)
            feature = -1
            c_table = CSV.read(table,headers:true)
            no_row = -2
            CSV.foreach(table) do |row|
                no_row = no_row + 1
                if row[0] == one_license
                    feature = c_table[no_row][key]
                end
            end
            #puts feature
            return feature
        end

        #对指定许可证列表进行排序，或按照可读性降序，或按照流行度降序（流行度暂时使用github数据）
        def self.sort(license_lst,mode)
            if mode == "complex"
                license_readability=Hash.new
                for one_license in license_lst do
                    license_readability[one_license]=License_sort.license_lookup(one_license,"lib\\license_readability.csv","mean")
                end
                license_readability_desc = license_readability.sort{|a, b| b[1]<=>a[1]}
                desc_res=[]      #可读性降序结果
                for license_read in license_readability_desc do
                    desc_res.push(license_read[0])
                end
            else
                license_popularity=Hash.new
                for one_license in license_lst do
                    license_popularity[one_license]=License_sort.license_lookup(one_license,"lib\\github_license_usage.csv","count").to_i
                end
                license_popularity_desc = license_popularity.sort{|a, b| b[1]<=>a[1]}
                desc_res=[]      #流行度降序结果
                for license_popular in license_popularity_desc do
                    desc_res.push(license_popular[0])
                end
            end
            return desc_res
        end
    
    end
end

# puts Licenserec::License_sort.sort(["FSFAP","WTFPL","ISC","Fair"],"complex")
# puts Licenserec::License_sort.sort(["CC0-1.0","EPL-1.0","LGPL-2"],"polular")
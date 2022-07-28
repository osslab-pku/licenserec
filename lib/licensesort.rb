# frozen_string_literal: true

require_relative "licenserec/version"
require 'csv'
require 'pathname'

module Licenserec
    class LicenseSort
        def initialize()
        end

        # 将csv转为哈希值。输入1为csv表，输入2为是否包含首行(默认包含)，输入3为列数i(转为hash的key)，输入4为列数j(转为hash的value)；输出为哈希表。
        def self.csv_to_hash(csv_table,header=true,i=0,j=1)
            sort_hash = Hash.new
            CSV.foreach(csv_table) do |row|
                if header
                    if $. != 1
                        sort_hash.store(row[i],row[j])
                    end
                else
                    sort_hash.store(row[i],row[j])
                end
            end
            return sort_hash
        end

        # 从排序哈希表中查询排序值。输入1为许可证SPDX,输入2为参照排序哈希表；输出为该许可证的排序值。
        def self.sortvalue_lookup(one_license,sort_hash)
            sortvalue = -1
            if sort_hash.has_key? one_license
                sortvalue = sort_hash.values_at(one_license)
            end
            return Float(sortvalue[0])
        end
        # 对指定许可证列表进行排序。输入1为指定的许可证列表，输入2为升降序(默认降序)，输入3为参照排序哈希表(key为许可证SPDX,value为参照值，默认按文本复杂度)；输出排序后的许可证列表。
        def self.license_sort(license_list,desc=true,sort_hash=LicenseSort.csv_to_hash(String(Pathname.new(File.dirname(__FILE__)).realpath)+"\\license_readability.csv",header=true,i=0,j=4))
            sort_res=[]
            license_initsort = Hash.new
            for one_license in license_list do
                license_initsort[one_license] = LicenseSort.sortvalue_lookup(one_license,sort_hash)
            end
            if desc
                license_sort_desc = license_initsort.sort{|a, b| b[1]<=>a[1]}
                for sort_value in license_sort_desc do
                    sort_res.push(sort_value[0]) # 降序结果
                end
            else
                license_sort_asc = license_initsort.sort{|a, b|  a[1]<=>b[1]}
                for sort_value in license_sort_asc do
                    sort_res.push(sort_value[0]) # 升序结果
                end
            end
            return sort_res
        end
    
    end
end


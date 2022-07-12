# frozen_string_literal: true

require_relative "licenserec/version"
require 'set'
require 'open3'
require 'csv'

module Licenserec
  class CompatibilityFilter
    def initialize(repo_path,licenseA_set,all_rec_licenses)
      puts "兼容许可证筛选"
      licenseA_set = CompatibilityFilter.license_detection(repo_path)
      licenseA_set.each do |ii|
        puts ii
      end
      rec1,rec2,rec12 = compatibility_filter(licenseA_set,all_rec_licenses)
      puts "rec1"
      puts rec1
      puts "rec2"
      puts rec2
      puts "rec12"
      puts rec12
    end

    def self.compatibility_meaning()
      compatibility_meaning_hash = Hash.new
      compatibility_meaning_hash.store("次级兼容","开源许可证A授权的作品（无论是否经过修改）与开源许可证B授权的作品组合，所产生的衍生作品整体可合法地使用开源许可证B重新授权时，则认为开源许可证A次级兼容开源许可证B。‘1’表示次级兼容。")
      compatibility_meaning_hash.store("组合兼容","开源许可证A授权的作品（无论是否经过修改）可以与开源许可证B授权的作品可以合法地组合而不违反任一开源许可证时，可以认为开源许可证A组合兼容开源许可证B。‘2’表示组合兼容。")
      compatibility_meaning_hash.store("不兼容","不满足次级兼容或组合兼容的条件，则不兼容。‘0’表示不兼容。")
    end

    # 遍历文件夹
    def self.show_files(f_path,repofiles_pathlist)
      if File.directory? f_path
        Dir.foreach(f_path) do |file|
          if file != "." and file != ".."
            show_files(f_path + "/" + file,repofiles_pathlist)
          end
        end
      else
        repofiles_pathlist.push(f_path)
      end
      return repofiles_pathlist
    end

    def self.ninka_process(filepath)
      io = IO.popen("perl E:\\ninka-tool\\ninka-master\\bin\\ninka.pl " + filepath)
      io_stdout = io.gets.split(";")
      file_license_list = io_stdout[1].split(",")
      return file_license_list
    end

    def self.license_detection(repo_path)
      # 遍历项目文件夹，获取项目中所有文件路径
      repofiles_pathlist = []
      repofiles_pathlist = show_files(repo_path,repofiles_pathlist)
      # 创建子进程，获取每个文件的许可证信息
      other_licenses = ["SeeFile", "UNKNOWN"]
      licenses_set = Set.new
      file_licenses_hash = {}
      repofiles_pathlist.each do |filepath|
        # 需要进行异常处理
        begin
          file_licenses = ninka_process(filepath)
          file_licenses_hash.store(filepath,file_licenses)
          dual_licenses = Set.new
          dual_licenses_str = ""
          file_licenses.each do |license_in_onefile|
            if other_licenses.include? license_in_onefile
              licenses_set.add("Other")
            elsif license_in_onefile.include? "NONE"
              licenses_set.add("")
            else
              if dual_licenses.include? license_in_onefile
                puts("")
              else
                dual_licenses_str = dual_licenses_str + license_in_onefile + ' or '
                dual_licenses.add(license_in_onefile)
              end
            end
            licenses_set.add(dual_licenses_str[0,dual_licenses_str.length-4])
            licenses_set.delete("")
          end
        rescue
            file_licenses_hash.store(filepath,"UNKNOWN")
            licenses_set.add("Other")
        end
      end
      licenses_set.delete(nil)
      return file_licenses_hash,licenses_set
    end

    def self.compatibility_lookup(licenseA,licenseB)
      compatibility_AB = -1
      c_table = CSV.read("E:\\OSSLSelection\\OSSLSelection\\csv\\compatibility_63.csv",headers:true)
      CSV.foreach("E:\\OSSLSelection\\OSSLSelection\\csv\\compatibility_63.csv") do |row|
        if row[0]==licenseA
          no_row = $.
          compatibility_AB = c_table[no_row-2][licenseB]
        end
      end
      return compatibility_AB
    end

    def compatibility_filter(licenseA_set,lisenseB_list)
      recommend_licenses_1 = []
      recommend_licenses_2 = []
      recommend_licenses_12 = []
      lisenseB_list.each { |licenseB|
        licenseA_set.each{ |licenseA|
          if licenseA.include? " or "
            licenseAs = licenseA.split(" or ")
            licenseAs.each{ |lA|
              compatibilityAB = CompatibilityFilter.compatibility_lookup(licenseA,licenseB)
              if compatibilityAB == "1"
                recommend_licenses_1.push(licenseB)
              elsif compatibilityAB == "2"
                recommend_licenses_2.push(licenseB)
              elsif compatibilityAB == "1,2"
                recommend_licenses_12.push(licenseB)
              end
            }
          else
            compatibilityAB = CompatibilityFilter.compatibility_lookup(licenseA,licenseB)
            if compatibilityAB == "1"
              recommend_licenses_1.push(licenseB)
            elsif compatibilityAB == "2"
              recommend_licenses_2.push(licenseB)
            elsif compatibilityAB == "1,2"
              recommend_licenses_12.push(licenseB)
            end
          end
        }
      }
      return recommend_licenses_1,recommend_licenses_2,recommend_licenses_12
    end
  end

  class CompatibilityCheck
    def initialize(repo_path)
      puts "兼容性冲突检查"
      ss = compatibilitycheck(repo_path)
      ss.each do |ii|
        puts ii
      end
    end
    def compatibilitycheck(repo_path)
      file_licenses_hash,licenses_set = CompatibilityFilter.license_detection(repo_path)
      c_table = CSV.read("E:\\OSSLSelection\\OSSLSelection\\csv\\compatibility_63.csv",headers:true)
      check_license_list = c_table["license"]
      # puts check_license_list
      confilct_copyleft_set = Set.new
      licenses_set.each do |licenseA|
        licenses_set.each do |licenseB|
          if (licenseA.include? " or ") == false
            iscompatibility = 0
            ischeck = 0
            if (licenseB.include? " or ") == false
              ischeck = 1
              compatibility_result_ab = CompatibilityFilter.compatibility_lookup(licenseA, licenseB)
              compatibility_result_ba = CompatibilityFilter.compatibility_lookup(licenseB, licenseA)
              if compatibility_result_ab != '0' or compatibility_result_ba != '0'
                iscompatibility = 1
              end
              if iscompatibility == 0 and ischeck == 1
                # puts licenseA+ "和" + licenseB + "互不兼容。"
                if (confilct_copyleft_set.include? licenseA+ "和" + licenseB + "互不兼容。") == false and (confilct_copyleft_set.include? licenseB+ "和" + licenseA + "互不兼容。") == false
                  confilct_copyleft_set.add(licenseA + "和" + licenseB + "互不兼容。")
                end
              end
            else
              licenseBs = licenseB.split(' or ')
              licenseBs.each do |lB|
                if check_license_list.include? lB
                  ischeck = 1
                  compatibility_result_ab = CompatibilityFilter.compatibility_lookup(licenseA, lB)
                  compatibility_result_ba = CompatibilityFilter.compatibility_lookup(lB, licenseA)
                  if compatibility_result_ab != '0' or compatibility_result_ba != '0'
                    iscompatibility = 1
                  end
                end
              end
              if iscompatibility == 0 and ischeck == 1
                # puts licenseA+ "和" + licenseB + "互不兼容。"
                if (confilct_copyleft_set.include? licenseA+ "和" + licenseB + "互不兼容。") == false and (confilct_copyleft_set.include? licenseB+ "和" + licenseA + "互不兼容。") == false
                  confilct_copyleft_set.add(licenseA + "和" + licenseB + "互不兼容。")
                end
              end
            end
          else
            iscompatibility = 0
            ischeck = 0
            licenseAs = licenseA.split(' or ')
            if (licenseB.include? " or ") == false
              licenseAs.each do |lA|
                if check_license_list.include? lA
                  ischeck = 1
                  compatibility_result_ab = CompatibilityFilter.compatibility_lookup(lA, licenseB)
                  compatibility_result_ba = CompatibilityFilter.compatibility_lookup(licenseB, lA)
                  if compatibility_result_ab != '0' or compatibility_result_ba != '0'
                    iscompatibility = 1
                    if iscompatibility == 0 and ischeck == 1
                      # puts licenseA+ "和" + licenseB + "互不兼容。"
                      if (confilct_copyleft_set.include? licenseA+ "和" + licenseB + "互不兼容。") == false and (confilct_copyleft_set.include? licenseB+ "和" + licenseA + "互不兼容。") == false
                        confilct_copyleft_set.add(licenseA + "和" + licenseB + "互不兼容。")
                      end
                    end
                  end
                end
              end
            else
              licenseBs = licenseB.split(' or ')
              licenseAs.each do |lA|
                licenseBs.each do |lB|
                  if check_license_list.include? lA and check_license_list.include? lB
                    ischeck = 1
                    compatibility_result_ab = CompatibilityFilter.compatibility_lookup(lA, lB)
                    compatibility_result_ba = CompatibilityFilter.compatibility_lookup(lB, lA)
                    if compatibility_result_ab != '0' or compatibility_result_ba != '0'
                      iscompatibility = 1
                    end
                    if iscompatibility == 0 and ischeck == 1
                      # puts licenseA+ "和" + licenseB + "互不兼容。"
                      if (confilct_copyleft_set.include? licenseA+ "和" + licenseB + "互不兼容。") == false and (confilct_copyleft_set.include? licenseB+ "和" + licenseA + "互不兼容。") == false
                        confilct_copyleft_set.add(licenseA + "和" + licenseB + "互不兼容。")
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      return confilct_copyleft_set
    end
  end

end


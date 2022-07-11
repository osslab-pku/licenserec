# frozen_string_literal: true

require_relative "licenserec/version"
require 'set'
require 'open3'
require 'csv'

module Licenserec
  class CompatibilityFilter
    def initialize(repo_path)
      puts "begin"
      puts license_detection(repo_path)   # 方法测试
      puts "end"
    end
    # 遍历文件夹
    def show_files(f_path,repofiles_pathlist)
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

    def ninka_process(filepath)
      io = IO.popen("perl E:\\ninka-tool\\ninka-master\\bin\\ninka.pl " + filepath)
      io_stdout = io.gets.split(";")
      file_license_list = io_stdout[1].split(",")
      return file_license_list
    end

    def license_detection(repo_path)
      # 遍历项目文件夹，获取项目中所有文件路径
      repofiles_pathlist = []
      repofiles_pathlist = show_files(repo_path,repofiles_pathlist)
      # 创建子进程，获取每个文件的许可证信息
      other_licenses = ["SeeFile", "UNKNOWN"]
      licenses_set = Set.new
      file_licenses_hash = {}
      repofiles_pathlist.each {|filepath|
        file_licenses = ninka_process(filepath)
        file_licenses_hash.store(filepath,file_licenses)
        dual_licenses = Set.new
        dual_licenses_str = ""
        file_licenses.each { |license_in_onefile|
          if other_licenses.include? license_in_onefile
            licenses_set.add("Other")
          elsif license_in_onefile.include? "NONE"
            licenses_set.add("")
          else
            if dual_licenses.include? license_in_onefile
              puts("1")
            else
              dual_licenses_str = dual_licenses_str + license_in_onefile + ' or '
              dual_licenses.add(license_in_onefile)
            end
          end
          licenses_set.add(dual_licenses_str[0,dual_licenses_str.length-4])
          licenses_set.delete("")
        }
      }
      return file_licenses_hash,licenses_set
    end

    def compatibility_lookup(licenseA,licenseB)
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
              compatibilityAB = compatibility_lookup(licenseA,licenseB)
              if compatibilityAB == "1"
                recommend_licenses_1.push(licenseB)
              elsif compatibilityAB == "2"
                recommend_licenses_2.push(licenseB)
              elsif compatibilityAB == "1,2"
                recommend_licenses_12.push(licenseB)
              end
            }
          else
            compatibilityAB = compatibility_lookup(licenseA,licenseB)
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
      puts compatibilitycheck(repo_path)
    end
    def compatibilitycheck(repo_path)
      file_licenses_hash,licenses_set = CompatibilityFilter.license_detection(repo_path)
      confilct_copyleft_set = Set.new
      licenses_set.each do |licenseA|
        licenses_set.each do |licenseB|
          if licenseA.include? " or " == false
            iscompatibility = 0
            ischeck = 0
            if licenseB.include? " or " == false
              ischeck = 1
              compatibility_result_ab = compatibility_judge(licenseA, licenseB)
              compatibility_result_ba = compatibility_judge(licenseB, licenseA)
              if compatibility_result_ab != '0' or compatibility_result_ba != '0'
                iscompatibility = 1
              end
              if iscompatibility == 0 and ischeck == 1
                if confilct_copyleft_set.include? licenseA+ "和" + licenseB + "互不兼容。"
                  confilct_copyleft_set.add(licenseA + "和" + licenseB + "互不兼容。")
                end
              end
            else
              licenseBs = licenseB.split(' or ')
              licenseBs.each do |lB|
                if check_license_list.include? lB
                  ischeck = 1
                  compatibility_result_ab = compatibility_judge(licenseA, lB)
                  compatibility_result_ba = compatibility_judge(lB, licenseA)
                  if compatibility_result_ab != '0' or compatibility_result_ba != '0'
                    iscompatibility = 1
                  end
                end
              end
              if iscompatibility == 0 and ischeck == 1
                if confilct_copyleft_set.include? licenseB + "和" + licenseA + "互不兼容。"
                  confilct_copyleft_set.add(licenseA + "和" + licenseB + "互不兼容。")
                end
              end
            end
          else
            iscompatibility = 0
            ischeck = 0
            licenseAs = licenseA.split(' or ')
            if licenseB.include? " or " == false
              licenseAs.each do |lA|
                if check_license_list.include? lA
                  ischeck = 1
                  compatibility_result_ab = compatibility_judge(lA, licenseB)
                  compatibility_result_ba = compatibility_judge(licenseB, lA)
                  if compatibility_result_ab != '0' or compatibility_result_ba != '0'
                    iscompatibility = 1
                    if iscompatibility == 0 and ischeck == 1
                      if confilct_copyleft_set.include? licenseB + "和" + licenseA + "互不兼容。"
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
                  if check_license_list.include? lA and check_license_list.include? lB:
                    ischeck = 1
                    compatibility_result_ab = compatibility_judge(lA, lB)
                    compatibility_result_ba = compatibility_judge(lB, lA)
                    if compatibility_result_ab != '0' or compatibility_result_ba != '0'
                      iscompatibility = 1
                    end
                    if iscompatibility == 0 and ischeck == 1
                      if onfilct_copyleft_set.include? licenseB + "和" + licenseA + "互不兼容。"
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
    end
  end

end


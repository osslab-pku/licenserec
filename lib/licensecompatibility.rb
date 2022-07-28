# frozen_string_literal: true

require_relative "licenserec/version"
require 'set'
require 'open3'
require 'csv'
require 'pathname'
module Licenserec
  class CompatibilityFilter
    def initialize()
    end

    # 次级兼容、组合兼容和不兼容的含义
    def self.compatibility_meaning()
      compatibility_meaning_hash = Hash.new
      compatibility_meaning_hash.store("次级兼容","开源许可证A授权的作品（无论是否经过修改）与开源许可证B授权的作品组合，所产生的衍生作品整体可合法地使用开源许可证B重新授权时，则认为开源许可证A次级兼容开源许可证B。本知识库中使用‘1’表示次级兼容。")
      compatibility_meaning_hash.store("组合兼容","开源许可证A授权的作品（无论是否经过修改）可以与开源许可证B授权的作品可以合法地组合而不违反任一开源许可证时，可以认为开源许可证A组合兼容开源许可证B。本知识库中使用‘2’表示组合兼容。")
      compatibility_meaning_hash.store("不兼容","不满足次级兼容或组合兼容的条件，则不兼容。本知识库中使用‘0’表示不兼容。")
      return compatibility_meaning_hash
    end

    # 遍历文件夹，返回所有文件的路径列表
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

    # 第三方工具Ninka识别文件许可证，一个文件可能包含多个许可证，输入1为文件的路径，输入2为ninka路径，输出为许可证列表。
    def self.ninka_process(filepath,ninka_path)
      io = IO.popen("perl " + ninka_path + " " + filepath)
      io_stdout = io.gets.split(";")
      file_license_list = io_stdout[1].split(",")
      # puts "++++++++++++++"
      # puts file_license_list
      return file_license_list
    end

    # 识别项目所包含的许可证，输入1为项目路径，输入2为ninka路径，输出1为文件路径及对应许可证信息的哈希表，输出2为项目包含的许可证集合
    def self.license_detection(repo_path,ninka_path)
      # 遍历项目文件夹，获取项目中所有文件路径
      repofiles_pathlist = []
      repofiles_pathlist = show_files(repo_path,repofiles_pathlist)
      # 创建子进程，获取每个文件的许可证信息
      other_licenses = ["SeeFile", "UNKNOWN"]
      licenses_set = Set.new
      file_licenses_hash = {}
      repofiles_pathlist.each do |filepath|
        # 异常处理
        begin
          file_licenses = CompatibilityFilter.ninka_process(filepath,ninka_path)
          dual_licenses = Set.new
          dual_licenses_str = ""
          if file_licenses.length <= 1
            if other_licenses.include? file_licenses[0]
              licenses_set.add("Other")
              file_licenses_hash.store(filepath,"Other")
            elsif file_licenses[0].include? "NONE"
              licenses_set.add("")
              file_licenses_hash.store(filepath,"NONE")
            elsif file_licenses[0].nil?
              licenses_set.add("")
              file_licenses_hash.store(filepath,"NONE")
            else
              licenses_set.add(file_licenses[0])
              file_licenses_hash.store(filepath,file_licenses[0])
            end
          else
            file_licenses.each do |license_in_onefile|
                if dual_licenses.include? license_in_onefile == false
                  dual_licenses_str = dual_licenses_str + license_in_onefile + ' or '
                  dual_licenses.add(license_in_onefile)
                end
              end
            licenses_set.add(dual_licenses_str[0,dual_licenses_str.length-4])
            file_licenses_hash.store(filepath,dual_licenses_str[0,dual_licenses_str.length-4])
          end
          licenses_set.delete("")
        rescue
          puts $!
        end
      end
      licenses_set.delete(nil)
      return file_licenses_hash,licenses_set
    end

    # 兼容性查询，输入1为许可证A(通常指项目中第三方组件的许可证)，输入2为许可证B(通常指项目许可证)，输出为"0"(不兼容)、"1"(次级兼容)、"2"(组合兼容)、"1,2"(次级兼容或组合兼容)。
    def self.compatibility_lookup(licenseA,licenseB)
      compatibility_AB = '1,2'
      cur_path=String(Pathname.new(File.dirname(__FILE__)).realpath)
      c_table = CSV.read(cur_path+"\\compatibility_63.csv",headers:true)
      CSV.foreach(cur_path+"\\compatibility_63.csv") do |row|
        if row[0]==licenseA
          no_row = $.
          compatibility_AB = c_table[no_row-2][licenseB]
        end
      end
      return compatibility_AB
    end

    # 兼容许可证筛选，输入1为项目路径，输入2为ninka路径，输入3为许可证推荐范围，其中默认值“popular”包含MIT等20种常见开源许可证，“all”包含本知识库支持的6种开源许可证。输出1为仅满足次级兼容的许可证列表，输出2为仅满足组合兼容的许可证列表，输出3为既满足次级兼容又满足组合兼容的许可证列表。
    def self.compatibility_filter(repo_path,ninka_path,recommand_scale="popular")
      filelicense_hash,licenseA_set = CompatibilityFilter.license_detection(repo_path,ninka_path)
      cur_path=String(Pathname.new(File.dirname(__FILE__)).realpath)
      c_table = CSV.read(cur_path+"\\compatibility_63.csv",headers:true)
      all_license = c_table['license']
      if recommand_scale == "popular"
        licenseB_list = %w[MIT Apache-2.0 GPL-3.0 BSD-3-Clause GPL-2.0 AGPL-3.0 MPL-2.0 LGPL-3.0 BSD-2-Clause Unlicense ISC EPL-1.0 CC0-1.0 LGPL-2.1 WTFPL Zlib EPL-2.0 Artistic-2.0 MulanPSL-2.0 MulanPubL-2.0]
      elsif recommand_scale == "all"
        licenseB_list = all_license.dup
      else
        puts "范围错误，请输入'popular'或'all'。"
      end
      checked_license = []
      recommend_licenses_1 = licenseB_list.dup
      recommend_licenses_2 = licenseB_list.dup
      recommend_licenses_12 = licenseB_list.dup
      licenseA_set.each { |licenseA|
        if licenseA.include? " or "
          dual_checked = 0
          licenseB_list.each { |licenseB|
            licenseAs = licenseA.split(" or ")
            is_remove_secondary = 1
            is_remove_combine = 1
            is_remove_both = 1
            licenseAs.each{ |lA|
              if all_license.include? lA
                compatibilityAB = CompatibilityFilter.compatibility_lookup(lA,licenseB)
                dual_checked = 1
                if compatibilityAB == "1" or compatibilityAB == '1,2'
                  is_remove_secondary = 0
                end
                if compatibilityAB == "2" or compatibilityAB == '1,2'
                  is_remove_combine = 0
                end
                if compatibilityAB == "1,2"
                  is_remove_both = 0
                end
              end
            }
            if is_remove_secondary and dual_checked ==1
              recommend_licenses_1.delete(licenseB)
            end
            if is_remove_combine and dual_checked ==1
              recommend_licenses_2.delete(licenseB)
            end
            if is_remove_both and dual_checked ==1
              recommend_licenses_12.delete(licenseB)
            end
          }
          if dual_checked == 1
            checked_license.push(licenseA)
          end
        else
          if all_license.include? licenseA
            checked_license.push(licenseA)
            licenseB_list.each { |licenseB|
              compatibilityAB = CompatibilityFilter.compatibility_lookup(licenseA,licenseB)
              if compatibilityAB != "1" and compatibilityAB != '1,2'
                recommend_licenses_1.delete(licenseB)
              end
              if compatibilityAB != "2" and compatibilityAB != '1,2'
                recommend_licenses_2.delete(licenseB)
              end
              if compatibilityAB != "1,2"
                recommend_licenses_12.delete(licenseB)
              end
            }
          end
        end
      }
      return recommend_licenses_1,recommend_licenses_2,recommend_licenses_12,checked_license
    end

  end

  class CompatibilityCheck
    def initialize()
    end

    # 兼容性检查，输入1为项目路径，输入2为ninka路径，输出为“OK”,或项目种包含互不兼容许可证的提示信息的集合、对应文件路径的列表
    def self.compatibilitycheck(repo_path,ninka_path)
      file_licenses_hash,licenses_set = CompatibilityFilter.license_detection(repo_path,ninka_path)
      cur_path=String(Pathname.new(File.dirname(__FILE__)).realpath)
      c_table = CSV.read(cur_path+"\\compatibility_63.csv",headers:true)
      check_license_list = c_table["license"]
      conflict_copyleft_infoset = Set.new
      conflict_licenses = Set.new
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
                if (conflict_copyleft_infoset.include? licenseA+ "和" + licenseB + "互不兼容。") == false and (conflict_copyleft_infoset.include? licenseB+ "和" + licenseA + "互不兼容。") == false
                  conflict_copyleft_infoset.add(licenseA + "和" + licenseB + "互不兼容。")
                  conflict_licenses.add(licenseA)
                  conflict_licenses.add(licenseB)
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
                if (conflict_copyleft_infoset.include? licenseA+ "和" + licenseB + "互不兼容。") == false and (conflict_copyleft_infoset.include? licenseB+ "和" + licenseA + "互不兼容。") == false
                  conflict_copyleft_infoset.add(licenseA + "和" + licenseB + "互不兼容。")
                  conflict_licenses.add(licenseA)
                  conflict_licenses.add(licenseB)
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
                      if (conflict_copyleft_infoset.include? licenseA+ "和" + licenseB + "互不兼容。") == false and (conflict_copyleft_infoset.include? licenseB+ "和" + licenseA + "互不兼容。") == false
                        conflict_copyleft_infoset.add(licenseA + "和" + licenseB + "互不兼容。")
                        conflict_licenses.add(licenseA)
                        conflict_licenses.add(licenseB)
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
                      if (conflict_copyleft_infoset.include? licenseA+ "和" + licenseB + "互不兼容。") == false and (conflict_copyleft_infoset.include? licenseB+ "和" + licenseA + "互不兼容。") == false
                        conflict_copyleft_infoset.add(licenseA + "和" + licenseB + "互不兼容。")
                        conflict_licenses.add(licenseA)
                        conflict_licenses.add(licenseB)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      conflict_filepath = []
      if conflict_copyleft_infoset.nil?
        return "OK",nil
      else
        conflict_licenses.each do |one_license|
          file_licenses_hash.each do |file_path,file_license|
            if file_license == one_license
              conflict_filepath.push(file_path + "----------" + file_license)
            end
          end
        end
        return conflict_copyleft_infoset,conflict_filepath
      end
    end
  end

end


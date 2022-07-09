# frozen_string_literal: true

require_relative "licenserec/version"
require 'set'
require 'open3'
require 'csv'

module Licenserec
  class CompatibilityFilter
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
      puts(repo_path)
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
        dual_licenses_str = Hash.new
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
          licenses_set.add(dual_licenses_str.first(dual_licenses_str.length-4))
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
          compatibilityAB = compatibility_lookup(licenseA,licenseB)
        }
      }
    end

  end
end


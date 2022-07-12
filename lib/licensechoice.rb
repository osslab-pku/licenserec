# frozen_string_literal: true

require_relative "licenserec/version"
require 'set'
require 'open3'
require 'csv'

module Licenserec
    class Termschoice
        def initialize()
        end

        def self.license_terms_choice(questions_val,init_licenselist)
            c_table = CSV.read("lib\\compatibility_63.csv",headers:true)
            licenses_spdx = c_table['license']
            licenses_copyleft = c_table['copyleft']
            licenses_copyright = c_table['copyright']
            licenses_patent = c_table['patent']
            licenses_patent_term = c_table['patent_term']
            licenses_trademark = c_table['trademark']
            licenses_interaction = c_table['interaction']
            licenses_modification = c_table['modification']

            licenses_copyleft.each do |x|
                puts x
            end
            # 初始化推荐列表
            licenselist_recommended = init_licenselist
            # 满足各个条款的列表的列表
            rr_license = []
            # 已选择的条款选项
            rr_question_var = []
            
            q2_show=1
            #Q1
            if questions_val[0] != ""
                # 满足该条款的许可证列表
                license_ok = []
                if questions_val[0] == '宽松型开源许可证'
                    q2_show = 0
                    licenses_copyleft.each_with_index do |x,i|
                        
                        if x.to_i == 0 && licenses_copyright[i].to_i != -1
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                elsif questions_val[0] == '限制型开源许可证'
                    licenses_copyleft.each_with_index do |x,i|
                        if x.to_i > 0
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                elsif questions_val[0] == '公共领域许可证'
                    q2_show = 0
                    licenses_copyright.each_with_index do |x,i|
                        if x.to_i == -1
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                end
                
                rr_license.push(license_ok)
                rr_question_var.push(questions_val[0])
            else
                rr_license.push(init_licenselist)
                rr_question_var.push(questions_val[0])
            end
            
            #Q2
            if q2_show == 1 && questions_val[1] != ""
                # 满足该条款的许可证列表
                license_ok = []
                if questions_val[1] == '文件级__弱限制型开源许可证'
                    licenses_copyleft.each_with_index do |x,i|
                        if x.to_i == 1
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                elsif questions_val[1] == '库级__弱限制型开源许可证'
                    licenses_copyleft.each_with_index do |x,i|
                        if x.to_i == 2
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                else
                    licenses_copyleft.each_with_index do |x,i|
                        if x.to_i == 3
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                end
                rr_license.push(license_ok)
                rr_question_var.push(questions_val[1])
            else
                rr_license.push(init_licenselist)
                rr_question_var.push(questions_val[1])

            end

            #Q3
            if questions_val[2] != ""
                # 满足该条款的许可证列表
                license_ok = []
                if questions_val[2] == '不提及专利权'
                    licenses_patent.each_with_index do |x,i|
                        if x.to_i == 0
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                elsif questions_val[2] == '明确授予专利权'
                    licenses_patent.each_with_index do |x,i|
                        if x.to_i == 1
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                else
                    licenses_patent.each_with_index do |x,i|
                        if x.to_i == -1
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                end
                rr_license.push(license_ok)
                rr_question_var.push(questions_val[2])
            else
                rr_license.push(init_licenselist)
                rr_question_var.push(questions_val[2])
            end

            #Q4
            if questions_val[3] != ""
                # 满足该条款的许可证列表
                license_ok = []
                if questions_val[3] == '包含反专利诉讼条款'
                    licenses_patent_term.each_with_index do |x,i|
                        if x.to_i == 1
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                else
                    licenses_patent_term.each_with_index do |x,i|
                        if x.to_i == 0
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                end
                rr_license.push(license_ok)
                rr_question_var.push(questions_val[3])
            else
                rr_license.push(init_licenselist)
                rr_question_var.push(questions_val[3])
            end
            
            #Q5
            if questions_val[4] != ""
                # 满足该条款的许可证列表
                license_ok = []
                if questions_val[4] == '不提及商标权'
                    licenses_trademark.each_with_index do |x,i|
                        
                        if x.to_i == 0
                            if licenses_spdx[i] == 'CC0-1.0'
                                puts 1
                            end
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                else
                    licenses_trademark.each_with_index do |x,i|
                        if x.to_i == 1
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                end
                rr_license.push(license_ok)
                rr_question_var.push(questions_val[4])
            else
                rr_license.push(init_licenselist)
                rr_question_var.push(questions_val[4])
            
            end
            
            #Q6
            if questions_val[5] != ""
                # 满足该条款的许可证列表
                license_ok = []
                if questions_val[5] == '网络部署公开源码'
                    licenses_interaction.each_with_index do |x,i|
                        if x.to_i == 1
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                else
                    licenses_interaction.each_with_index do |x,i|
                        if x.to_i == 0
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                end

                rr_license.push(license_ok)
                rr_question_var.push(questions_val[5])
            else
                rr_license.push(init_licenselist)
                rr_question_var.push(questions_val[5])
            
            end

            #Q7
            if questions_val[6] != ""
                # 满足该条款的许可证列表
                license_ok = []
                if questions_val[6] == '包含修改说明条款'
                    licenses_modification.each_with_index do |x,i|
                        if x.to_i == 1
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                else
                    licenses_modification.each_with_index do |x,i|
                        if x.to_i == 0
                            license_ok.push(licenses_spdx[i])
                        end
                    end
                end
                rr_license.push(license_ok)
                rr_question_var.push(questions_val[6])
            else
                rr_license.push(init_licenselist)
                rr_question_var.push(questions_val[6])
            end

            terms_choice = []

            for i in 0..6

                licenselist_recommended=licenselist_recommended & rr_license[i]
                licenselist_recommended=licenselist_recommended.sort
                if rr_question_var[i] != ""
                    terms_choice.push(rr_question_var[i])
                end
            end

            
            # puts licenselist_recommended
            # puts terms_choice

            return licenselist_recommended, terms_choice
        end
    end
end


Licenserec::Termschoice.license_terms_choice(['宽松型开源许可证','','不提及专利权','不包含反专利诉讼条款','不提及商标权','不网络部署公开源码','不包含修改说明条款'],["NTP","CC0-1.0","Unlicense","WTFPL","0BSD","MIT-0","Fair","MIT","ISC","FSFAP","Imlib2"])
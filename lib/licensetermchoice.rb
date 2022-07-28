# frozen_string_literal: true

require_relative "licenserec/version"
require 'set'
require 'open3'
require 'csv'
require 'pathname'
module Licenserec
    class TermsChoice
        def initialize()
        end

        # 开源许可证条款要素名称、含义及要素值
        def self.terms_meaning()
            terms_meaning_hash = Hash.new
            terms_meaning_hash.store("info","是指许可证名称及版本号、发布日期、许可证版权声明及许可证原文链接地址等信息。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("preamble","对许可证的适用场景或适用条件、条款接受说明、以及目的宗旨等进行说明，如GPL序言部分。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("define","对许可证条款中的特定术语进行说明，便于用户理解许可证内容。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("copyright","对许可证授予的版权范围进行说明。‘-1’表示放弃版权投入公共领域，‘1’表示明确授予版权，‘0’表示模糊授予版权。")
            terms_meaning_hash.store("patent","对许可证授予的专利权范围进行说明。‘-1’表示不授予专利权，‘1’表示明确授予专利权，‘0’表示未提及。")
            terms_meaning_hash.store("trademark","对许可证不授予商标权进行说明。‘1’表示明确不授予商标权，‘0’表示未提及。")
            terms_meaning_hash.store("copyleft","一种授权条件，即衍生作品分发的再授权方式，其中“无限制”表示衍生作品可以使用其他许可证授权分发；“文件级弱限制”表示衍生作品可以使用其他许可证授权分发，只要确保衍生作品中该文件级弱限制许可证授权的文件及其修改仍然遵循该许可证，如MPL-2.0；“库级弱限制”表示衍生作品可以使用其他许可证授权分发，只要确保衍生作品中该库级弱限制许可证授权的库及其修改仍然遵循该许可证，如LGPL-2.1；“强限制”表示衍生作品的整体及其部分都必须按照该许可证授权分发。‘0’表示无限制，‘1’表示文件级弱限制，‘2’表示库级弱限制，‘3’表示强限制。")
            terms_meaning_hash.store("interaction","一种授权条件，是指使用原创作品或衍生作品，通过网络向用户提供服务等行为，须按照该许可证公开源码的要求。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("modification","一种授权条件，是指分发衍生作品，须添加修改声明（如修改者、修改时间、修改内容等）的要求。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("retain_attr","一种授权条件，是指原创作品或衍生作品的分发，须保留原归属信息（如版权声明等）的要求。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("enhance_attr","一种授权条件，是指原创作品或衍生作品的分发，除了要求保留归属外，还须以某种特定的形式声明软件的版权信息和作者的要求。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("acceptance","一种授权条件，是指原创作品或衍生作品的分发，必须做出合理的努力，以获得接收人对该许可证条款的明确同意的要求。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("patent_term","是指禁止任何人对该许可证授权的作品发起专利诉讼（否则终止其在该作品或该许可证下的专利授权）的要求。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("vio_term","是指许可证中可能包含的因违约而终止授权的条件或补救条件。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("disclaimer","对不提供担保进行澄清声明。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("law","对许可证对应的准据法进行说明，用于处理许可证的解释和争议问题。‘1’表示明确包含该条款，‘0’表示未提及。")
            terms_meaning_hash.store("instruction","提供许可证应用模板及明确模板放置位置。‘1’表示包含使用说明，‘0’表示未提及。")
            terms_meaning_hash.store("compatible_version","是对于后续可能发布的更多版本的兼容性进行说明，以便用户可以在后续版本下分发许可作品和衍生作品。逗号分隔的许可证SPDX字符串。")
            terms_meaning_hash.store("secondary_license","是对于现有的其他开源许可证的兼容性进行说明，以便用户可以在次级许可证下分发许可作品和衍生作品。逗号分隔的许可证SPDX字符串。")
            terms_meaning_hash.store("gpl_combine","GPL类许可证中关于能否与其他GPL许可证组合的说明。逗号分隔的许可证SPDX字符串。")
            return terms_meaning_hash
        end

        # 开源许可证关键条款及说明
        def self.important_terms_instruction()
            important_terms_instruction_hash = Hash.new
            important_terms_instruction_hash.store("开源许可证类型","宽松型开源许可证授权的作品允许其衍生作品，在满足原开源许可证
                                              要求的前提下，可以使用与原开源许可证不同的其他许可证(甚至商业许可
                                              证)进行再授权，如 MIT、Apache-2.0、MulanPSL-2.0 等；限制型开源许可
                                              证授权的作品要求其衍生作品须在其相同或兼容许可证下进行再授权，如
                                              MPL-2.0、GPL-2.0、OSL-3.0。")
            important_terms_instruction_hash.store("衍生作品分发限制性强弱","弱限制型许可证要求对作品修改后的重新分发必须按照获得该作品的
                                              许可证进行授权,但允许将代码与其他作品组合，组合作品整体可采用其他
                                              许可证授权，只要确保该弱限制型许可证授权的部分及其修改仍然遵循该许
                                              可证的约束，按照其约束范围可分为“文件级_弱限制型开源许可证”(如
                                              MPL-2.0)和“库级_弱限制型开源许可证”(如 LGPL-2.1)；“强限制型”
                                              许可证要求对作品的修改或组合后的分发都必须按照获得该作品的许可证进
                                              行开源,如 GPL-2.0、OSL-3.0 等。")
            important_terms_instruction_hash.store("专利授权","开源软件中可能包含软件专利，软件的可专利性是开源软件正在面临
                                              的威胁之一。开源许可证可以通过专利授权条款明确提供免费的专利许可，
                                              也可能不提及专利许可(该场景主要出现在早期的开源许可证中，如 MIT、
                                              GPL-2.0)，或者明确排除免费专利许可(该场景较为少见，如 BSD-3-
                                              Clause-clear)。明确的专利授权有利于保护开源软件的用户免受专利诉讼，
                                              尤其是面向一些拥有大量专利组合和其他专利组合风险的企业用户，他们普
                                              遍很重视专利权的授予。")
            important_terms_instruction_hash.store("专利诉讼终止","“专利诉讼终止”是指禁止任何人就许可作品发起专利诉讼，否则将
                                              终止其获得的相关权利，例如 Apache-2.0 要求任何人不得对其授权的用户
                                              发起专利诉讼，否则其在该作品下通过 Apache-2.0 获得的专利授权将被终
                                              止。“反专利诉讼”的目的是阻止人们提起关于许可作品的专利诉讼，为用
                                              户提供保障。")
            important_terms_instruction_hash.store("商标权限制","开源软件中可能包含商标，开源许可证可以明确对商标权的限制(即
                                              不授予商标权)，或禁止借商标权人的名义进行广告或宣传(如 BSD-3-
                                              Clause)；开源许可证也可能不提及商标权(如 MIT、BSD-2-Clause)，但原
                                              则上不涉及商标权许可，如需使用开源软件中出现的商标，应额外获得商标
                                              权人的许可。明确“不授予商标权”有利于保护许可方的合法权益，建议在
                                              开源许可证或其他声明通知中明确对商标权的限制，避免用户误用。")
            important_terms_instruction_hash.store("网络部署","“网络部署公开源码”是使用这类许可作品进行网络部署(如通过网络
                                              与用户交互的方式提供在线服务等)，即使许可作品的物理副本并未被分
                                              发，也须按照获得该作品的许可证授权其源代码，例如在云中使用
                                              AGPL3.0 许可的衍生软件提供在线服务也须要发布其源代码。该条款主要
                                              用于避免云厂商使用开源代码盈利而不向开源社区提供贡献的场景。")
            important_terms_instruction_hash.store("修改声明","“修改声明”是指要求用户分发衍生作品时伴随的声明通知，用以标
                                              记修改内容、日期、修改作者等信息。“修改说明”有利于增强开源软件贡
                                              献者的可见性和软件的可维护性，然而也可能导致被许可人无意违规。")
            return important_terms_instruction_hash
        end

        # 查询某个开源许可证的某个条款要素的值。输入1为许可证的SPDX，输入2为条款要素名称。输出为要素值，其中--。
        def self.license_term_lookup(one_license,one_term)
            term_feature = -1
            cur_path=String(Pathname.new(File.dirname(__FILE__)).realpath)
            c_table = CSV.read(cur_path+"\\licenses_terms_63.csv",headers:true)
            CSV.foreach(cur_path+"\\licenses_terms_63.csv") do |row|
                if row[0] == one_license
                    no_row = $.
                    term_feature = c_table[no_row-2][one_term]
                end
            end
            return term_feature
        end

        # 根据条款要素值，从推荐许可证列表中，筛选符合要求的许可证，输出更新的推荐许可证列表。输入1为条款要素名称，输入2为推荐许可证列表，输入3为条款要素值(String)。
        def self.license_term_choice(one_term,recommended_licenses,term_option)
            remove_licenses = []
            recommended_licenses.each do |one_license|
                term_feature = TermsChoice.license_term_lookup(one_license,one_term)
                if term_feature != String(term_option)
                    remove_licenses.push(one_license)
                end
            end
            recommended_licenses = recommended_licenses - remove_licenses
            return recommended_licenses
        end


        # def self.license_terms_choice(questions_val,init_licenselist)
        #     c_table = CSV.table("lib\\licenses_terms_63.csv")
        #     licenses_spdx = c_table[:license]
        #     licenses_copyleft = c_table[:copyleft]
        #     licenses_copyright = c_table[:copyright]
        #     licenses_patent = c_table[:patent]
        #     licenses_patent_term = c_table[:patent_term]
        #     licenses_trademark = c_table[:trademark]
        #     licenses_interaction = c_table[:interaction]
        #     licenses_modification = c_table[:modification]
        #
        #
        #     # licenses_copyleft.each do |x|
        #     #     puts "#{x}"
        #     # end
        #     # 初始化推荐列表
        #     licenselist_recommended = init_licenselist
        #     # 满足各个条款的列表的列表
        #     rr_license = []
        #     # 已选择的条款选项
        #     rr_question_var = []
        #
        #     q2_show=1
        #     #Q1
        #     if questions_val[0] != ""
        #         # 满足该条款的许可证列表
        #         license_ok = []
        #         if questions_val[0] == '宽松型开源许可证'
        #             q2_show = 0
        #             licenses_copyleft.each_with_index do |x,i|
        #
        #
        #                 if x.to_i == 0 && licenses_copyright[i].to_i != -1
        #                     license_ok.push(licenses_spdx[i])
        #
        #                 end
        #             end
        #         elsif questions_val[0] == '限制型开源许可证'
        #             licenses_copyleft.each_with_index do |x,i|
        #                 if x.to_i > 0
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         elsif questions_val[0] == '公共领域许可证'
        #             q2_show = 0
        #             licenses_copyright.each_with_index do |x,i|
        #                 if x.to_i == -1
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         end
        #
        #         rr_license.push(license_ok)
        #         rr_question_var.push(questions_val[0])
        #     else
        #         rr_license.push(init_licenselist)
        #         rr_question_var.push(questions_val[0])
        #     end
        #
        #     #Q2
        #     if q2_show == 1 && questions_val[1] != ""
        #         # 满足该条款的许可证列表
        #         license_ok = []
        #         if questions_val[1] == '文件级__弱限制型开源许可证'
        #             licenses_copyleft.each_with_index do |x,i|
        #                 if x.to_i == 1
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         elsif questions_val[1] == '库级__弱限制型开源许可证'
        #             licenses_copyleft.each_with_index do |x,i|
        #                 if x.to_i == 2
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         else
        #             licenses_copyleft.each_with_index do |x,i|
        #                 if x.to_i == 3
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         end
        #         rr_license.push(license_ok)
        #         rr_question_var.push(questions_val[1])
        #     else
        #         rr_license.push(init_licenselist)
        #         rr_question_var.push(questions_val[1])
        #
        #     end
        #
        #     #Q3
        #     if questions_val[2] != ""
        #         # 满足该条款的许可证列表
        #         license_ok = []
        #         if questions_val[2] == '不提及专利权'
        #             licenses_patent.each_with_index do |x,i|
        #                 if x.to_i == 0
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         elsif questions_val[2] == '明确授予专利权'
        #             licenses_patent.each_with_index do |x,i|
        #                 if x.to_i == 1
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         else
        #             licenses_patent.each_with_index do |x,i|
        #                 if x.to_i == -1
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         end
        #         rr_license.push(license_ok)
        #         rr_question_var.push(questions_val[2])
        #     else
        #         rr_license.push(init_licenselist)
        #         rr_question_var.push(questions_val[2])
        #     end
        #
        #     #Q4
        #     if questions_val[3] != ""
        #         # 满足该条款的许可证列表
        #         license_ok = []
        #         if questions_val[3] == '包含反专利诉讼条款'
        #             licenses_patent_term.each_with_index do |x,i|
        #                 if x.to_i == 1
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         else
        #             licenses_patent_term.each_with_index do |x,i|
        #                 if x.to_i == 0
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         end
        #         rr_license.push(license_ok)
        #         rr_question_var.push(questions_val[3])
        #     else
        #         rr_license.push(init_licenselist)
        #         rr_question_var.push(questions_val[3])
        #     end
        #
        #     #Q5
        #     if questions_val[4] != ""
        #         # 满足该条款的许可证列表
        #         license_ok = []
        #         if questions_val[4] == '不提及商标权'
        #             licenses_trademark.each_with_index do |x,i|
        #
        #                 if x.to_i == 0
        #
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         else
        #             licenses_trademark.each_with_index do |x,i|
        #                 if x.to_i == 1
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         end
        #         rr_license.push(license_ok)
        #         rr_question_var.push(questions_val[4])
        #     else
        #         rr_license.push(init_licenselist)
        #         rr_question_var.push(questions_val[4])
        #
        #     end
        #
        #     #Q6
        #     if questions_val[5] != ""
        #         # 满足该条款的许可证列表
        #         license_ok = []
        #         if questions_val[5] == '网络部署公开源码'
        #             licenses_interaction.each_with_index do |x,i|
        #                 if x.to_i == 1
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         else
        #             licenses_interaction.each_with_index do |x,i|
        #                 if x.to_i == 0
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         end
        #
        #         rr_license.push(license_ok)
        #         rr_question_var.push(questions_val[5])
        #     else
        #         rr_license.push(init_licenselist)
        #         rr_question_var.push(questions_val[5])
        #
        #     end
        #
        #     #Q7
        #     if questions_val[6] != ""
        #         # 满足该条款的许可证列表
        #         license_ok = []
        #         if questions_val[6] == '包含修改说明条款'
        #             licenses_modification.each_with_index do |x,i|
        #                 if x.to_i == 1
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         else
        #             licenses_modification.each_with_index do |x,i|
        #                 if x.to_i == 0
        #                     license_ok.push(licenses_spdx[i])
        #                 end
        #             end
        #         end
        #         rr_license.push(license_ok)
        #         rr_question_var.push(questions_val[6])
        #     else
        #         rr_license.push(init_licenselist)
        #         rr_question_var.push(questions_val[6])
        #     end
        #
        #     terms_choice = []
        #
        #     for i in 0..6
        #         licenselist_recommended=licenselist_recommended & rr_license[i]
        #         licenselist_recommended=licenselist_recommended.sort
        #         if rr_question_var[i] != ""
        #             terms_choice.push(rr_question_var[i])
        #         end
        #     end
        #
        #
        #     puts licenselist_recommended
        #     puts terms_choice
        #
        #     return licenselist_recommended, terms_choice
        # end
    end
end

# Test
# Licenserec::TermsChoice.license_terms_choice(['宽松型开源许可证','','不提及专利权','不包含反专利诉讼条款','不提及商标权','不网络部署公开源码','不包含修改说明条款'],["NTP","CC0-1.0","Unlicense","WTFPL","0BSD","MIT-0","Fair","MIT","ISC","FSFAP","Imlib2"])
# puts Licenserec::TermsChoice.license_term_lookup("OSL-3.0","patent")
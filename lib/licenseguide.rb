# frozen_string_literal: true

require_relative "licenserec/version"


module Licenserec
  class LicensetypeGuide
    def initialize()
      puts "许可证选择向导"
      puts LicensetypeGuide.os_style_guide()
      puts LicensetypeGuide.os_business_guide()
      puts LicensetypeGuide.os_community_guide()
      puts LicensetypeGuide.business_model_feature()
    end

    def self.os_style_guide()
      os_style_hash = Hash.new
      os_style_hash.store("支持持续共享","也称 copyleft的“自由”哲学理念，支持该理念的开发者不但
                          开放源码，而且鼓励用户自由使用、自由复制、自由修改和自由分发，且在传播过程
                          中一直要保持自由，要求用户对该软件进行修改、改进和再分发时，要严格接受自由
                          的运行规则。限制型开源许可证允许用户自由地使用、复制、修改和分发软件，重新
                          分发修改后的衍生软件通常须要在相同的开源许可证(或其兼容的开源许可证)下授权，
                          可以确保软件的持续开源。")
      os_style_hash.store("支持用户权利","支持该理念的开发者对于开放源码的传播具有更多的包容性，
                          他们允许用户自由使用、自由复制、自由修改和自由分发，同时不限制他们分发的方
                          式，用户拥有更多的自主权。宽松型开源许可证允许用户自由地使用、复制、修改和
                          分发软件，且重新分发修改后的软件允许用户重新选择许可方式，甚至闭源。")
      os_style_hash.store("投入公共领域","支持该理念的开发者不在乎他人如何使用其软件。将软件放
                          置公共领域，意味着开发者放弃对软件的版权保护，公共领域许可证(如 Unlicense)可
                          以用于声明放弃版权保护。")
      return os_style_hash
    end

    def self.os_business_guide()
      os_business_hash = Hash.new
      os_business_hash.store("扩大用户基础","支持服务、开放核心等商业模式依赖于广泛
                              的用户基础，宽松型开源许可证和限制型开源许可证的主要区别在于，宽松型开源许
                              可证允许用户在自己的产品中集成开源代码，不必将代码开源，因此宽松型开源许可
                              证对于商业用户比较友好。")
      os_business_hash.store("减少同行竞争","软件的源代码始终是软件厂商的核心价值之
                              一，分叉(Fork)虽然可以鼓励创新，但也会带来开发者的分裂出走以及潜在竞争，限
                              制型开源许可证对于衍生软件的发布要求不同程度的开放自己的源代码，一定程度较
                              少了竞争对手利用开源软件制作私有产品的机会，从而减少同行竞争。")
      os_business_hash.store("控制产品发展","如何有效控制软件发展方向，对于开源厂商
                              具有战略意义，限制型开源许可证可以减少代码分叉，且所有开发的内容都可以保留
                              下来，有助于掌握软件开发的动向；开源厂商还可以通过参与开源软件的决策(如成
                              为 PMC)或者签订额外协议(如 CLA)来获得对软件的足够控制。")
      return os_business_hash
    end

    def self.os_community_guide()
      os_community_hash = Hash.new
      os_community_hash.store("用户","宽松型开源许可证
                                对任何用户来说都没有压力，而开源许可证的互惠性越强，从衍生产品中生产专有产
                                品就越困难，降低了对那些想要制作专有衍生软件的商业用户的吸引力。")
      os_community_hash.store("贡献者","。限制型开源许可证使软件保持开放的特性，往往能产生更强的社会认同感，且对
                                那些寻求如工作挑战、同行认可等高度内在动机的贡献者具有一定吸引力；宽松型开
                                源许可证项目主要吸引的贡献者，不仅出于内在动机，还具有希望获得商业化潜在机
                                会、声誉和地位等外在动机，较高的用户数量能使他们的技能得到更好的展示。")
      os_community_hash.store("合作伙伴或竞争对手","。限制型开源许可证一定程度上为合作伙伴或竞争对手提供信
                                用，即保证他们的努力不会被第三方直接闭源并商业化。")
      return os_community_hash
    end

    def self.business_model_feature()
      business_model_hash = Hash.new()
      business_model_hash.store("支持服务","通过围绕开源产品的培训、咨询或扩展开发等形式来提供辅助产品和增值服
                                务。互补产品或服务的需求随着开源软件被更广泛地采用而增加。")
      business_model_hash.store("双重授权","软件在两个独立的许可证下提供，通常一个版本在开源许可证下授权，开源
                                版本通常具有 Copyleft 条款(GPL 风格)的，可以避免竞争对手从访问源码中
                                获得搭便车的好处，另一个版本在商业许可证下授权，商业许可证允许软
                                件与其他专有软件组合，因此那些不希望受 copyleft 条款约束的商业集成用户
                                可以购买商业许可。该模式主要面向商业“嵌入式”客户。")
      business_model_hash.store("业务源","软件使用两个具有时间延迟的不同许可证，源代码通常在设定的时间内(如 3
                                年)必须付费才能使用，在这个时间段后，许可证自动更改为开源许可证。
                                这种模式可以同时满足开源社区和开源商业用户的需求，然而开源许可证过
                                于严格会损害社区的发展，过于宽松则会损害业务的发展，例如 MariaDB 在
                                BSL-1.1(with GPL-2.0+)要求衍生软件也遵循相同的条款(即首次公开发布
                                特定版本的许可作品的四年后，使用 GPL-2.0+进行开源)。")
      business_model_hash.store("开放核心","在开源许可下提供核心基础代码，在商业许可下提供专有代码，专有部分可
                                能打包为与开源基础部分连接的单独模块或服务，也可能与开源基础部分一
                                起作为付费版本分发。核心产品越有用，社区的潜在兴趣就越大；从终端用
                                户的角度来看，开放核心会导致厂商锁定，在吸引和维护开发人员方面可能
                                存在潜在消极影响；容易出现了一个相互竞争的分叉产品。")
      business_model_hash.store("开放核心+混合许可","在开放核心模式基础上进行了改进，同一个代码库中包含了开源代码和专有
                                代码，用户可以选择只使用开源代码，或者同时使用开源代码和专有代码。
                                代码在同一个代码库，方便管理和开发，且方便用户升级到付费模式，不需
                                要额外部署；且允许外部社区对专有代码进行改进，但需要遵循许可证约
                                定，例如，CockroachDB 采用 CCL(free)+CCL(paid)，允许用户查看和修改源
                                码，但未经 Cockroach Labs 同意不能重用代码。")
      business_model_hash.store("附加限制条件","软件在开源许可证的基础上附加其他限制条款，例如 Apache-2.0 with
                                Common Clause1.0，其中 Common Clause 主要禁止他人直接利用开源软件牟
                                利，以促进自身业务需求。开源厂商依然需要选择一个基本的主许可证，附
                                加的条款可能定义模糊，通常须要法院认定，例如 Common Clause 没有经过
                                OSI 认证，因此添加了 Common Clause 的软件不再是传统意义上的开源软
                                件，只能说源码可用(source available)。")
      business_model_hash.store("软件即服务","利用开源软件通过互联网提供服务，但是软件并没有分发给他们的用户。
                                SaaS 与开源没有直接关系，但它可以合并开源组件或直接使用开源软件。")
      business_model_hash.store("广告或版税","企业还可以通过广告合作、品牌授权、销售商业软件等方式创造利益，例如
                                Mozilla 公司通过与雅虎(Yahoo)合作，在 Firefox 火狐浏览器中使用雅虎成为
                                默认搜索引擎获得收入等。")
      return business_model_hash
    end

  end



end

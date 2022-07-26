# frozen_string_literal: true

require_relative "lib/licenserec/version"

Gem::Specification.new do |spec|
  spec.name = "licenserec"
  spec.version = Licenserec::VERSION
  spec.authors = ["osslab-pku"]
  spec.email = ["blesswoo@pku.edu.cn"]

  spec.summary = "Licenserec是一个用于开源许可证选择的ruby库"
  spec.description = "Licenserec是一个用于开源许可证选择的ruby库，提供许可证兼容性查询、许可证兼容性检查、项目兼容许可证筛选、许可证条款特征查询、许可证条款特征对比、许可证类型选择观点、许可证关键条款解读等功能。"
  spec.homepage = "https://gitee.com/blesswoo/licenserec"
  spec.required_ruby_version = ">= 2.4.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/osslab-pku/licenserec"
  spec.metadata["changelog_uri"] = "https://github.com/osslab-pku/licenserec"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.executables = %w{ licenserec.rb }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

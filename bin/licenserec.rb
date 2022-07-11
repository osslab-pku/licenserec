#!/usr/bin/env ruby

# 因为 bwgem.gemspec 文件中的 spec.require_paths = %w{ lib }, 所以可以使用 `require` 直接加载 `lib` 文件夹中的文件
require 'licenserec'

puts "这是一个简单的 Ruby 库"

puts Licenserec::CompatibilityFilter.new("E:\\ninka-tool\\ninka-master")
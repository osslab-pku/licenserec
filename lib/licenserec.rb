# frozen_string_literal: true

require_relative "licenserec/version"

module Licenserec
  class Error < StandardError; end
  # Your code goes here...
  require 'licensecompatibility'
  require 'licenseguide'
  require 'licensechoice'
  require 'licensecompare'
end

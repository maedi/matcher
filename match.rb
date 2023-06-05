#!/usr/bin/env ruby

require 'pry'
require_relative 'matcher'

matcher = Matcher.new
matcher.match($1, $2)

require 'pry'
require_relative 'tree'

File.readlines('jobs.csv').each_with_index do |line, index|
  next if index == 0

  job = line.strip.split(',')
  id, title, *skills = job

  # skills = skills.split(',')

  binding.pry
  p skills
end
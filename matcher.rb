require 'pry'
require_relative 'job'
require_relative 'combination_tree'

jobs = {}
tree = CombinationTree.new

File.readlines('jobs.csv').each_with_index do |line, index|
  next if index == 0

  id, title, *skills = line.strip.delete('"').split(',')
  job = Job.new(id, title, skills)
  jobs[job.id] = job

  tree.branch([], job.skills, job.id)
end

binding.pry

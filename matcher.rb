require 'pry'
require_relative 'job'
require_relative 'seeker'
require_relative 'combination_tree'

class Matcher
  def initialize
    @jobs = {}
    @job_tree = CombinationTree.new
    @seekers = {}
  end

  def match(jobs_path, seekers_path)
    build_jobs(jobs_path)
    match_seekers(seekers_path)
    binding.pry
  end

  def build_jobs(jobs_path)
    jobs_path = 'jobs.csv' if jobs_path.nil?

    File.readlines(jobs_path).each_with_index do |line, index|
      next if index == 0

      id, title, *skills = normalize_line(line)
      job = Job.new(id, title, skills)
      @jobs[job.id] = job

      @job_tree.branch([], job.skills, job.id)
    end
  end

  def match_seekers(seekers_path)
    seekers_path = 'jobseekers.csv' if seekers_path.nil?

    File.readlines(seekers_path).each_with_index do |line, index|
      next if index == 0

      id, name, *skills = normalize_line(line)
      seeker = Seeker.new(id, name, skills)
      @seekers[seeker.id] = seeker

      seeker_tree = CombinationTree.new
      seeker_tree.branch([], seeker.skills)
      binding.pry
    end
  end

  private

  def normalize_line(line)
    line.strip.delete('"').split(',')
  end
end

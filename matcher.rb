require 'pry'
require_relative 'job'
require_relative 'seeker'
require_relative 'combination_tree'
require_relative 'renderer'

class Matcher
  def initialize
    @jobs = {}
    @job_tree = CombinationTree.new
    @seekers = {}
  end

  def match(jobs_path, seekers_path)
    build_jobs(jobs_path)
    build_seekers(seekers_path)

    renderer = Renderer.new(@jobs)
    renderer.render(@seekers)
  end

  private

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

  def build_seekers(seekers_path)
    seekers_path = 'jobseekers.csv' if seekers_path.nil?

    File.readlines(seekers_path).each_with_index do |line, index|
      next if index == 0

      id, name, *skills = normalize_line(line)

      seeker_tree = CombinationTree.new
      seeker_tree.branch([], skills)

      seeker = Seeker.new(id, name, skills, match_seeker_with_jobs(seeker_tree))
      @seekers[seeker.id] = seeker
    end
  end

  def match_seeker_with_jobs(seeker_tree)
    matches = {}

    seeker_tree.tree.each do |seeker_branch, seeker_value|
      next unless @job_tree.tree.include? seeker_branch
      
      job_branch = @job_tree.tree[seeker_branch]

      job_branch[:items].each do |job_id|
        # Don't overwrite existing matches with larger combinations.
        # An advanced performance optimisation would be to create multiple smaller/specific `CombinationTree`s,
        # based on some reductive characteristic of:
        # - The job seeker such as amount of skills entered or years of experience
        # - The job such as whether it's an active listing
        unless matches.include?(job_id) && matches[job_id][:combo].count > job_branch[:combo].count
          matches[job_id] = match_data(job_branch[:combo], job_id)
        end
      end
    end

    matches
  end

  def match_data(combo, job_id)
    {
      combo: combo,
      job_id: job_id,
    }
  end

  def normalize_line(line)
    id, *values = line.strip.delete('"').split(',')

    [id.to_i, *values]
  end
end

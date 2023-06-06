require 'pry'

class Renderer
  def initialize(jobs)
    @jobs = jobs
  end

  def render(results)
    results.each do |result|
      id, seeker = result

      sorted_matches = seeker.matches.sort_by { |id, value| [-value[:combo].count, id] }

      sorted_matches.each do |match_result|
        job_id, match = match_result
        job = @jobs[job_id]
      
        #binding.pry
        puts [seeker.id, seeker.name, job.id, job.title, match[:combo].count].join(', ')
      end
    end
  end
end

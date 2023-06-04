class Job
  attr_reader :id, :title, :skills

  def initialize(id, title, skills)
    @id = id
    @title = title
    @skills = skills
  end
end

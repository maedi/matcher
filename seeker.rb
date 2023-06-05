class Seeker
  attr_reader :id, :name, :skills, :matches

  def initialize(id, name, skills, matches)
    @id = id
    @name = name
    @skills = skills
    @matches = matches
  end
end

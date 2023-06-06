# Matcher

Matches jobs and their requirements with job seekers and their skills.

## Installation

Run `bundle install --path vendor/bundle`

Built with Ruby 2.6 but should work with most versions.

## Usage

Run `bundle exec ruby match.rb`

## Description

I could have gone for a simple for-loop that went through each job seeker, then for that job seeker looped through each job and matched skills... but that wouldn't scale well as jobs and job seekers increased. I haven't researched the best way to do this, instead in the spirit of hacking and experimentation I have created a "Combination Tree" that allows for `O(1)` matching of a job seeker to jobs matching those skills. Essentially the time complexity of jobs/seekers is moved to the space complexity of skills. The combinations of skills grows exponentially as they are added, but it's the one dataset out of the 3 (job/seeker/skill) that is more controllable. On a practical level as job seekers increase in volumne, their skills start to cluster into smaller and more specific combinations. That's the theory anyway, more real world data, tweaking and benchmarking is needed :)

Internally the combination tree's structure looks like this:
```ruby
@tree = {
  "javascript" => {:combo => ["javascript"], :items => [1, 3, 7]},
  "css" => {:combo => ["css"], :items => [1, 3]},
  "html" => {:combo => ["html"], :items => [1, 3, 7]},
  "css html" => {:combo => ["css", "html"], :items => [1, 3]},
  "css html javascript" => {:combo => ["css", "html", "javascript"], :items => [1, 3]},
  "css javascript" => {:combo => ["css", "javascript"], :items => [1, 3]},
  "sql" => {:combo => ["sql"], :items => [2, 3, 4, 6, 8, 9]},
  "c#" => {:combo => ["c#"], :items => [2, 6]},
  "java" => {:combo => ["java"], :items => [2, 5, 8]},
  "c# java" => {:combo => ["c#", "java"], :items => [2]},
  "c# java sql" => {:combo => ["c#", "java", "sql"], :items => [2]},
  "c# sql" => {:combo => ["c#", "sql"], :items => [2, 6]},
  "html javascript ruby" => {:combo => ["html", "javascript", "ruby"], :items => [3]},
  "html javascript" => {:combo => ["html", "javascript"], :items => [3, 7]},
  "javascript ruby" => {:combo => ["javascript", "ruby"], :items => [3]},
  "ruby" => {:combo => ["ruby"], :items => [3, 3, 5]},
  "css html javascript ruby" => {:combo => ["css", "html", "javascript", "ruby"], :items => [3]},
  "css html javascript ruby sql" => {:combo => ["css", "html", "javascript", "ruby", "sql"], :items => [3]},
  "css html javascript sql" => {:combo => ["css", "html", "javascript", "sql"], :items => [3]},
  "css html ruby" => {:combo => ["css", "html", "ruby"], :items => [3]},
  "css html ruby sql" => {:combo => ["css", "html", "ruby", "sql"], :items => [3]},
  "css html sql" => {:combo => ["css", "html", "sql"], :items => [3]},
  "css javascript ruby" => {:combo => ["css", "javascript", "ruby"], :items => [3]},
  "css javascript ruby sql" => {:combo => ["css", "javascript", "ruby", "sql"], :items => [3]},
  "css javascript sql" => {:combo => ["css", "javascript", "sql"], :items => [3]},
  "css ruby" => {:combo => ["css", "ruby"], :items => [3]},
  "css ruby sql" => {:combo => ["css", "ruby", "sql"], :items => [3]},
  "css sql" => {:combo => ["css", "sql"], :items => [3]},
  "statistics" => {:combo => ["statistics"], :items => [4]},
  "python" => {:combo => ["python"], :items => [4, 5, 9]},
  "python sql" => {:combo => ["python", "sql"], :items => [4, 9]},
  "python sql statistics" => {:combo => ["python", "sql", "statistics"], :items => [4]},
  "python statistics" => {:combo => ["python", "statistics"], :items => [4]},
  "java python" => {:combo => ["java", "python"], :items => [5]},
  "java python ruby" => {:combo => ["java", "python", "ruby"], :items => [5]},
  "java ruby" => {:combo => ["java", "ruby"], :items => [5]},
  "dev ops" => {:combo => ["dev ops"], :items => [6]},
  "c# dev ops" => {:combo => ["c#", "dev ops"], :items => [6]},
  "c# dev ops sql" => {:combo => ["c#", "dev ops", "sql"], :items => [6]},
  "java sql" => {:combo => ["java", "sql"], :items => [8]}
}
```

A combination tree is also created for each job seeker and then its keys/combinations matched with those in the job combination tree:

```ruby
@seekers => {
  1 => {
    @id = 1,
    @matches = {
      3 => {:combo => ["javascript", "ruby"], :job_id => 3},
      5 => {:combo => ["python"], :job_id => 5},
      1 => {:combo => ["javascript"], :job_id => 1},
      7 => {:combo => ["javascript"], :job_id => 7},
      4 => {:combo => ["python"], :job_id => 4},
      9 => {:combo => ["python"], :job_id => 9}},
    @name = "Alice",
    @skills = ["JavaScript", "Ruby", "Python"]
  },
  2 => {
    @id = 2,
    @matches = {
      2 => {:combo => ["c#", "java", "sql"], :job_id => 2},
      3 => {:combo => ["sql"], :job_id => 3},
      4 => {:combo => ["sql"], :job_id => 4},
      6 => {:combo => ["c#", "dev ops", "sql"], :job_id => 6},
      8 => {:combo => ["java"], :job_id => 8},
      9 => {:combo => ["sql"], :job_id => 9},
      5 => {:combo => ["java"], :job_id => 5}},
    @name ="Bob",
    @skills = ["Java", "C#", "SQL", "Dev Ops"]
  },
  3 => {
    @id = 3,
    @matches = {
      1 => {:combo => ["css", "html", "javascript"], :job_id => 1},
      3 => {:combo => ["css", "html", "javascript"], :job_id => 3},
      7 => {:combo => ["html"], :job_id => 7}},
    @name = "Charlie",
    @skills = ["JavaScript", "HTML", "CSS"]
  },
}
```

## Output

```
1, Alice, 3, Full Stack Developer, 2
1, Alice, 1, Frontend Developer, 1
1, Alice, 4, Data Analyst, 1
1, Alice, 5, Software Engineer, 1
1, Alice, 7, JavaScript Developer, 1
1, Alice, 9, Python Developer, 1
2, Bob, 2, Backend Developer, 3
2, Bob, 6, Systems Engineer, 3
2, Bob, 3, Full Stack Developer, 1
2, Bob, 4, Data Analyst, 1
2, Bob, 5, Software Engineer, 1
2, Bob, 8, Java Developer, 1
2, Bob, 9, Python Developer, 1
3, Charlie, 1, Frontend Developer, 3
3, Charlie, 3, Full Stack Developer, 3
3, Charlie, 7, JavaScript Developer, 1
4, Dave, 5, Software Engineer, 3
4, Dave, 2, Backend Developer, 1
4, Dave, 3, Full Stack Developer, 1
4, Dave, 4, Data Analyst, 1
4, Dave, 8, Java Developer, 1
4, Dave, 9, Python Developer, 1
5, Eve, 2, Backend Developer, 2
5, Eve, 4, Data Analyst, 2
5, Eve, 6, Systems Engineer, 2
5, Eve, 9, Python Developer, 2
5, Eve, 3, Full Stack Developer, 1
5, Eve, 5, Software Engineer, 1
5, Eve, 8, Java Developer, 1
6, Frank, 1, Frontend Developer, 3
6, Frank, 3, Full Stack Developer, 3
6, Frank, 7, JavaScript Developer, 1
7, Greg, 5, Software Engineer, 3
7, Greg, 2, Backend Developer, 1
7, Greg, 3, Full Stack Developer, 1
7, Greg, 4, Data Analyst, 1
7, Greg, 8, Java Developer, 1
7, Greg, 9, Python Developer, 1
8, Hannah, 2, Backend Developer, 3
8, Hannah, 6, Systems Engineer, 2
8, Hannah, 3, Full Stack Developer, 1
8, Hannah, 4, Data Analyst, 1
8, Hannah, 5, Software Engineer, 1
8, Hannah, 8, Java Developer, 1
8, Hannah, 9, Python Developer, 1
9, Ivan, 3, Full Stack Developer, 2
9, Ivan, 1, Frontend Developer, 1
9, Ivan, 4, Data Analyst, 1
9, Ivan, 5, Software Engineer, 1
9, Ivan, 7, JavaScript Developer, 1
9, Ivan, 9, Python Developer, 1
10, Jane, 2, Backend Developer, 3
10, Jane, 6, Systems Engineer, 2
10, Jane, 3, Full Stack Developer, 1
10, Jane, 4, Data Analyst, 1
10, Jane, 5, Software Engineer, 1
10, Jane, 8, Java Developer, 1
10, Jane, 9, Python Developer, 1
```

# frozen_string_literal: true

class CombinationTree
  attr_reader :tree

  def initialize(combination_min = 0)
    @tree = {}

    # Optionally increase for more specific matches in less time.
    @combination_min = combination_min
  end

  def branch(combination, terms, item = nil)
    terms = terms.sort.map(&:downcase)

    combination << terms.shift
    combination_key = create_key(combination)
    
    if combination.count >= @combination_min
      @tree[combination_key] = branch_data(combination) unless @tree.include? combination_key
      @tree[combination_key][:items] << item unless item.nil?
    end

    while terms.count > 0
      branch(combination.clone, terms.clone, item)
      terms.shift
    end
  end

  private

  def branch_data(combination)
    {
      combo: combination,
      items: [],
    }
  end

  def create_key(combination)
    combination.join(' ')
  end
end

# frozen_string_literal: true

class CombinationTree
  def initialize
    @tree = {}
  end

  def branch(combination, terms, item)
    terms = terms.sort.map(&:downcase)

    combination << terms.shift
    combination_key = create_key(combination)
    
    @tree[combination_key] = results_data(combination) unless @tree.include? combination_key
    @tree[combination_key][:items] << item

    while terms.count > 0
      branch(combination.clone, terms.clone, item)
      terms.shift
    end
  end

  private

  def results_data(combination)
    {
      combo: combination,
      items: [],
    }
  end

  def create_key(combination)
    combination.join(' ')
  end
end

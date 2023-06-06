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

    branch_recursively(combination, terms, item)
  end

  def branch_recursively(combination, terms, item)
    # Each branch combination is unique until the last singular combination, which isn't, and would result in duplicates.
    # So instead we create the last branch once and terminate each recursive branch before it gets to that point.
    create_or_update_branch([terms.last], item) if combination.empty?

    # Define the current branch.
    combination << terms.shift
    create_or_update_branch(combination, item)

    # Remove terms from the end of the combination.
    # [a, b, c, d]
    #           ^
    local_combo = terms.clone
    local_combo.pop
    while local_combo.count > 0
      create_or_update_branch(local_combo.clone, item)
      local_combo.pop
    end

    # Remove terms from the start of the combination and do it all again for each smaller recursive branch.
    # [a, b, c, d]
    #  ^
    while terms.count > 0
      branch_recursively(combination.clone, terms.clone, item)
      terms.shift
    end
  end

  private

  def create_or_update_branch(combination, item)
    return if combination.count <= @combination_min

    combination_key = create_key(combination)

    @tree[combination_key] = branch_data(combination) unless @tree.include? combination_key
    @tree[combination_key][:items] << item unless item.nil?
  end

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

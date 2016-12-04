# frozen_string_literal: true

# Text manipulation methods
module WordMagic
  def reasonable_search_terms(search_terms)
    safe_search_terms = search_terms&.downcase&.gsub(/[^0-9a-zA-Z]/, '+')
    safe_search_terms&.split('+')&.select { |w| w.size > 1 }
  end

  def contains_search_terms?(title, search_terms)
    search_terms.any? { |term| title&.downcase&.include?(term) }
  end
end

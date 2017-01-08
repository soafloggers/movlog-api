# frozen_string_literal: true

# Text manipulation methods
module WordMagic
  def reasonable_search_terms(search_terms)
    safe_search_terms = search_terms&.downcase&.gsub(/[^0-9a-zA-Z]/, '+')
    safe_search_terms&.split('+')&.select { |w| w.size > 1 }
  end

  def reasonable_search_whole_term(whole_term)
    safe_search_terms = whole_term&.downcase&.gsub(/[^0-9a-zA-Z]/, '+')
  end

  def contains_search_terms?(title, search_terms)
    search_terms.any? { |term| title&.downcase&.include?(term) }
  end

  def split_search_terms(search_terms)
    safe_search_terms = search_terms&.gsub(/, /, '+')
    safe_search_terms&.split('+')&.select { |w| w.size > 1 }
  end

  def url_decode(search_term)
    search_term.gsub(/\+/, ' ').gsub(/%20/, ' ')
  end
end

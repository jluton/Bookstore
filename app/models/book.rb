class Book < ApplicationRecord
  belongs_to :publisher
  belongs_to :author
  has_many :book_reviews
  has_many :book_formats

  def book_format_types
    book_formats.map(&:book_format_type)
  end

  def author_name
    author.full_name
  end

  def average_rating
    book_reviews.sum {|r| r.rating.to_f} / book_reviews.length
  end

  def self.search(query, options)
    
  end
end

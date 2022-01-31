class Book < ApplicationRecord
  belongs_to :publisher
  belongs_to :author
  has_many :book_reviews
  has_many :book_formats

  def book_format_types
    # Returns a collection of the BookFormatTypes this book is available in

  end

  def author_name
    # The name of the author of this book in “lastname, firstname” format
  end

  def average_rating
    # The average (mean) of all the book reviews for this book.  Rounded to one decimal place.  
  end

  def self.search(query, options)
    
  end
end

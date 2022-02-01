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

  def self.search(query, options = {})
    matches = []

    title_matches = self.where("title like ?", "%#{query}%")
    matches = matches.concat title_matches if title_matches
    return matches if options.key?(:title_only) && options[:title_only]

    author = Author.find_by("last_name like ?", "#{query}")
    matches = matches.concat author.books if author

    publisher = Publisher.find_by("name like ?", "#{query}")
    matches = matches.concat publisher.books if publisher

    matches = matches.uniq

    if options.key?(:book_format_type_id) && options[:book_format_type_id]
      matches = matches.select do |book|
        BookFormat.find_by(book_id: book.id, book_format_type_id: options[:book_format_type_id])
      end
    end

    if options.key?(:book_format_physical) && options[:book_format_physical]
      matches = matches.select do |book|
        book.book_format_types.any?(&:physical)
      end
    end

    matches
  end
end

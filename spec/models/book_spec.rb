require 'rails_helper'

RSpec.describe Book, type: :model do
  book = FactoryBot.create(:book)

  it 'returns book format types' do
    physical_format = FactoryBot.create(:book_format_type, name: 'hardcover', physical: true)
    digital_format = FactoryBot.create(:book_format_type, name: 'epub', physical: false)
    FactoryBot.create(:book_format, book: book, book_format_type: physical_format)
    FactoryBot.create(:book_format, book: book, book_format_type: digital_format)

    format_types = book.book_format_types
    expect(format_types.length).to eq(2)
    expect(format_types.first.id).to eq(physical_format.id)
    expect(format_types.last.id).to eq(digital_format.id) 
  end

  it 'returns author name' do
    author = book.author

    expect(book.author_name).to eq("#{author.first_name} #{author.last_name}")
  end

  it 'returns average rating' do
    FactoryBot.create(:book_review, book: book, rating: 2)
    FactoryBot.create(:book_review, book: book, rating: 5)

    expect(book.average_rating).to eq(3.5)
  end
end

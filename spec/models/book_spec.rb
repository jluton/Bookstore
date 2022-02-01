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

  it 'searches by exact author last name' do
    author1 = FactoryBot.create(:author, last_name: 'Smith')
    author2 = FactoryBot.create(:author, last_name: 'Smithsson')
    book1 = FactoryBot.create(:book, author: author1)
    book2 = FactoryBot.create(:book, author: author1)
    book3 = FactoryBot.create(:book, author: author2)

    result = Book.search('smith')
    expect(result.length).to eq(2)
    expect(result.first.id).to eq(book1.id)
    expect(result.last.id).to eq(book2.id)
  end

  it 'searches by exact publisher name' do
    publisher1 = FactoryBot.create(:publisher, name: 'Brody & Mack')
    publisher2 = FactoryBot.create(:publisher, name: 'Brody & Macksson')
    book1 = FactoryBot.create(:book, publisher: publisher1)
    book2 = FactoryBot.create(:book, publisher: publisher1)
    book3 = FactoryBot.create(:book, publisher: publisher2)

    result = Book.search('Brody & Mack')
    expect(result.length).to eq(2)
    expect(result.first.id).to eq(book1.id)
    expect(result.last.id).to eq(book2.id)
  end

  it 'searches by partial title' do
    book1 = FactoryBot.create(:book, title: 'The Errant Fool')
    book2 = FactoryBot.create(:book, title: 'Fool\'s Gold')
    book3 = FactoryBot.create(:book, title: 'Errant Knights')

    result = Book.search('Fool')
    expect(result.length).to eq(2)
    expect(result.first.id).to eq(book1.id)
    expect(result.last.id).to eq(book2.id)
  end

  it 'does not duplicate search results' do
    author = FactoryBot.create(:author, last_name: 'Errant')
    book = FactoryBot.create(:book, title: 'The Errant Fool', author: author)

    result = Book.search('Fool')
    expect(result.length).to eq(1)
    expect(result.first.id).to eq(book.id)
  end

  it 'searches by title only' do
    author = FactoryBot.create(:author, last_name: 'Errant')
    book1 = FactoryBot.create(:book, title: 'The Errant Fool')
    book2 = FactoryBot.create(:book, author: author)

    result = Book.search('Errant', { title_only: true })
    expect(result.length).to eq(1)
    expect(result.first.id).to eq(book1.id)
  end

  it 'filters search by book format type' do
    book1 = FactoryBot.create(:book, title: 'The Errant Fool')
    book2 = FactoryBot.create(:book, title: 'Errant Knights')
    format_type = FactoryBot.create(:book_format_type)
    FactoryBot.create(:book_format, book: book1, book_format_type: format_type)

    result = Book.search('Errant', { book_format_type_id: format_type.id })
    expect(result.length).to eq(1)
    expect(result.first.id).to eq(book1.id)
  end

  it 'filters search by physical formats' do
    book1 = FactoryBot.create(:book, title: 'The Errant Fool')
    book2 = FactoryBot.create(:book, title: 'Errant Knights')
    format_type1 = FactoryBot.create(:book_format_type, physical: true)
    format_type2 = FactoryBot.create(:book_format_type, physical: false)
    FactoryBot.create(:book_format, book: book1, book_format_type: format_type1)
    FactoryBot.create(:book_format, book: book2, book_format_type: format_type2)

    result = Book.search('Errant', { book_format_physical: true })
    expect(result.length).to eq(1)
    expect(result.first.id).to eq(book1.id)
  end
end

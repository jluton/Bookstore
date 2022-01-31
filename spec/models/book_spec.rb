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
    expect(format_types.last.id).to eq(digit_format.id) 
  end
end

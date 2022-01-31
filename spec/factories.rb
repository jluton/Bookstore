FactoryBot.define do
  factory :book do
    title { 'The little green man' }
    association :publisher
    association :author
  end

  factory :author do
    first_name { 'John' }
    last_name  { 'Doe' }
  end

  factory :publisher do
    name { 'Big Books Inc.'}
  end

  factory :book_format_type do
    name { 'epub' }
    physical { false }
  end

  factory :book_format do
    association :book
    association :book_format_type
  end
end
class SupportingColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :publishers do |t|
      t.string :name

      t.timestamps
    end

    create_table :authors do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    create_table :book_format_types do |t|
      t.string :name
      t.boolean :physical

      t.timestamps
    end

    create_table :book_formats do |t|
      t.references :book
      t.references :book_format_type

      t.timestamps
    end

    create_table :book_reviews do |t|
      t.references :book
      t.integer :rating, nil: false
      # I would place a validation on the model requiring rating to be >= 1 and <= 5.

      t.timestamps
    end
  end
end

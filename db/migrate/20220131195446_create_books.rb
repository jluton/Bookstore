class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :publisher_id
      t.integer :author_id
      # In a real model I would use t.references, but those models do not exist in this exercise

      t.timestamps
    end
  end
end

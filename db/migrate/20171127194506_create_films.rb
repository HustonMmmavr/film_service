class CreateFilms < ActiveRecord::Migration[5.1]
  def change
    create_table :films do |t|
      t.text :about
      t.integer :year
      t.string :image
      t.float :rating
      t.string :director
      t.string :title
      t.int :length

      t.timestamps
    end
  end
end

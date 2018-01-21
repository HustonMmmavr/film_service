class CreateAccessApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :access_applications do |t|
      t.string :appName
      t.string :appSecret
      t.integer :life
      t.datetime :created

      t.timestamps
    end
  end
end

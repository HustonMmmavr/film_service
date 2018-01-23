class AddAppTokenToAccessApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :access_applications, :appToken, :string
  end
end

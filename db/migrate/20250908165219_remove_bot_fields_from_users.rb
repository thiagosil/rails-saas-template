class RemoveBotFieldsFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :role, :integer
    remove_column :users, :bot_token, :string
  end
end

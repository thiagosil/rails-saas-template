class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest
      t.integer :role, default: 0
      t.boolean :active, default: true
      t.string :bot_token

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :bot_token, unique: true
  end
end

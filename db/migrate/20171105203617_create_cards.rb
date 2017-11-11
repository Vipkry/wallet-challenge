class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :name_written
      t.string :number
      t.date :expiration_date
      t.integer :user_wallet_id
      t.integer :cvv
      t.integer :due_day
      t.decimal :spent
      t.decimal :limit

      t.timestamps
    end
  end
end

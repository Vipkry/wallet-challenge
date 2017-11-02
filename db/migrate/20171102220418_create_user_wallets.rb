class CreateUserWallets < ActiveRecord::Migration[5.1]
  def change
    create_table :user_wallets do |t|
      t.decimal :custom_limit
      t.integer :user_id
      t.decimal :limit

      t.timestamps
    end
  end
end

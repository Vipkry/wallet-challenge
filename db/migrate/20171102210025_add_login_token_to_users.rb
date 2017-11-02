class AddLoginTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :login_token, :string
  end
end

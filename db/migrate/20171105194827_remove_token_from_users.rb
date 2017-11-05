class RemoveTokenFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :token, :string
  end
end

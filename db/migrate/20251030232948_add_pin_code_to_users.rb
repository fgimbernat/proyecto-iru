class AddPinCodeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :pin_code, :string
  end
end

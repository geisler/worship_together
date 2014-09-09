class AddDetailsToUser < ActiveRecord::Migration
  def change
    add_reference :users, :church, index: true
    add_column :users, :phone_number, :string
    add_column :users, :picture, :binary
  end
end

class CreateUserRides < ActiveRecord::Migration
  def change
    create_table :user_rides do |t|
      t.references :user, index: true
      t.references :ride, index: true

      t.timestamps
    end
  end
end

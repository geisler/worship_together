class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.references :user, index: true
      t.references :service, index: true
      t.date :date
      t.time :leave_time
      t.time :return_time
      t.integer :number_of_seats
      t.integer :seats_available
      t.string :meeting_location
      t.text :vehicle

      t.timestamps
    end
  end
end

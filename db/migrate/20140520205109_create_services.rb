class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.references :church, index: true
      t.string :day_of_week
      t.time :start_time
      t.time :finish_time
      t.string :location

      t.timestamps
    end
  end
end

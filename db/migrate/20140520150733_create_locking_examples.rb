class CreateLockingExamples < ActiveRecord::Migration
  def change
    create_table :locking_examples do |t|
      t.string :name
      t.integer :lock_version

      t.timestamps
    end
  end
end

class CreateChurches < ActiveRecord::Migration
  def change
    create_table :churches do |t|
      t.references :user, index: true
      t.string :name
      t.binary :picture
      t.string :web_site
      t.text :description

      t.timestamps
    end
  end
end

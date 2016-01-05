class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name
      t.integer :template
      t.text :code
      t.timestamps
    end
  end
end

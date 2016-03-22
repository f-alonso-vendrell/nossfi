class CreateGroupers < ActiveRecord::Migration
  def change
    create_table :groupers do |t|
      t.string :name
      t.integer :template
      t.text :code

      t.timestamps
    end
  end
end

class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.integer :template
      t.integer :creator
      t.string :recipients
      t.boolean :private

      t.timestamps
    end
  end
end

class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :title
      t.string :desc
      t.integer :version
      t.string :fields
      t.boolean :aprovable
      t.boolean :acknowledgeable
      t.string :defaultemail

      t.timestamps
    end
  end
end

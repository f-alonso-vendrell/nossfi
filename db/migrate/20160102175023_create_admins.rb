class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.text :data

      t.timestamps
    end
  end
end

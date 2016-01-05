class AddDataToForm < ActiveRecord::Migration
  def change
  	add_column :forms, :data, :string
  end
end

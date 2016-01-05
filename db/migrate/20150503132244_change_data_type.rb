class ChangeDataType < ActiveRecord::Migration
  def change
  	change_column :forms, :data,  :text
  end
end

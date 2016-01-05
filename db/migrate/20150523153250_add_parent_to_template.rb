class AddParentToTemplate < ActiveRecord::Migration
  def change
  	add_column :templates, :parent, :integer
  end
end

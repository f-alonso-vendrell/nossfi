class AddChildformsToTemplate < ActiveRecord::Migration
  def change
  	add_column :templates, :childforms, :integer
  end
end

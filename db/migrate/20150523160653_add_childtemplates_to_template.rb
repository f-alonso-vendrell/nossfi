class AddChildtemplatesToTemplate < ActiveRecord::Migration
  def change
  	add_column :templates, :childtemplates, :integer
  end
end

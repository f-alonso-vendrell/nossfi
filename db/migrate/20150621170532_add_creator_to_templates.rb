class AddCreatorToTemplates < ActiveRecord::Migration
  def change
  	add_column :templates, :creator, :integer
  end
end

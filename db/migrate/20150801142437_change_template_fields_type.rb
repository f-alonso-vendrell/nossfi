class ChangeTemplateFieldsType < ActiveRecord::Migration
  def change
  	change_column :templates, :fields,  :text
  end
end

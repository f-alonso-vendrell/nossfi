class ChangeTemplateColumnNameInForm < ActiveRecord::Migration
  def change
  	rename_column :forms, :template, :template_id
  end
end

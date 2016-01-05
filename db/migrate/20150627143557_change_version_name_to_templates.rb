class ChangeVersionNameToTemplates < ActiveRecord::Migration
  def change
  	rename_column :templates, :version, :templateVersion
  end
end

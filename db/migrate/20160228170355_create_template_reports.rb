class CreateTemplateReports < ActiveRecord::Migration
  def change
    create_table :template_reports do |t|
      t.string :title
      t.string :desc
      t.string :fields
      t.string :data
      t.integer :creator

      t.timestamps
    end
  end
end

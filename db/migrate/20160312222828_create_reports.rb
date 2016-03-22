class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :template_report_id
      t.integer :creator
      t.text :data
      t.text :result

      t.timestamps
    end
  end
end

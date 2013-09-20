class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :admin_user, index: true
      t.references :user_event, index: true
      t.string :schema

      t.timestamps
    end
  end
  
  def down
    drop_table(:reports)
  end
end

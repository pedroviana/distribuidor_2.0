class CreateAdminUserEvents < ActiveRecord::Migration
  def change
    create_table :admin_user_events do |t|
      t.references :admin_user, index: true
      t.references :event, index: true

      t.timestamps
    end
  end
end

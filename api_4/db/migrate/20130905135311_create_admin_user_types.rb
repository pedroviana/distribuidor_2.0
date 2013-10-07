class CreateAdminUserTypes < ActiveRecord::Migration
  def change
    create_table :admin_user_types do |t|
      t.string :title

      t.timestamps
    end
  end
end

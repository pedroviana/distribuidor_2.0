class CreateAdminUserTypeAreas < ActiveRecord::Migration
  def change
    create_table :admin_user_type_areas do |t|
      t.references :admin_user_type, index: true
      t.references :area, index: true

      t.timestamps
    end
  end
end

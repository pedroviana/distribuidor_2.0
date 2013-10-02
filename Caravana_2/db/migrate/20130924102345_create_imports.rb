class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.references :admin_user

      t.timestamps
    end
    add_index :imports, :admin_user_id
  end
end

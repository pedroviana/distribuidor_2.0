class AddImportReferencesInEvents < ActiveRecord::Migration
  def up
    change_table(:events) do |t|
      t.references :import
    end
    
    add_index :events, :import_id
  end
end

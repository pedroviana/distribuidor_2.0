class AddBooleanParsedToImports < ActiveRecord::Migration
  def change
    change_table(:imports) do |t|
      t.boolean :parsed, :default => false, :null => false
    end
  end
end

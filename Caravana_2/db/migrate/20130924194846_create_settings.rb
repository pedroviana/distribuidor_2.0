class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key
      t.string :value
      t.boolean :ative

      t.timestamps
    end
  end
end

class AddEmailSearchBooleanToUserEvent < ActiveRecord::Migration
  def change
    change_table(:user_events) do |t|
      t.boolean :email_search, default: false
    end
  end
end

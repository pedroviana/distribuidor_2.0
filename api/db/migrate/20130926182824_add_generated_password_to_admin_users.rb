class AddGeneratedPasswordToAdminUsers < ActiveRecord::Migration
  def change
    change_table(:admin_users) do |t|
      t.string :generated_password
    end
  end
end

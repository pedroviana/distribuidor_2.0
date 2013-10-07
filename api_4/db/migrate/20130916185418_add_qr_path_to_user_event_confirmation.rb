class AddQrPathToUserEventConfirmation < ActiveRecord::Migration
  def change
    change_table(:user_event_confirmations) do |t|
      t.string :qr_path
    end
  end
end

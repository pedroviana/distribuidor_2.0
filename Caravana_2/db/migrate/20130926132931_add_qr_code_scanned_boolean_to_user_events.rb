class AddQrCodeScannedBooleanToUserEvents < ActiveRecord::Migration
  def change
    change_table(:user_events) do |t|
      t.boolean :qr_code_scanned, :default => false, :null => false
    end
  end
end

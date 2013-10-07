class AddQrSentAtUserEventConfirmation < ActiveRecord::Migration
  def change
    change_table(:user_event_confirmations) do |t|
      t.datetime :qr_sent_at, default: nil
    end
  end
end

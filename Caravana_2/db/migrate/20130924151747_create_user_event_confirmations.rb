class CreateUserEventConfirmations < ActiveRecord::Migration
  def change
    create_table :user_event_confirmations do |t|
      t.references :user_event
      t.string :function
      t.string :address
      t.string :number
      t.string :complement
      t.string :cep
      t.string :state
      t.string :city
      t.string :cellnumber
      t.boolean :smartphone
      t.boolean :sms_usage
      t.boolean :email_usage
      t.boolean :image_usage
      
      t.datetime :qr_sent_at, default: nil
      t.string :qr_path

      t.timestamps
    end
    add_index :user_event_confirmations, :user_event_id
  end
end

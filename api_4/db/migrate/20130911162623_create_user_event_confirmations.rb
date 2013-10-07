class CreateUserEventConfirmations < ActiveRecord::Migration
  def change
    create_table :user_event_confirmations do |t|
      t.references :user_event, index: true
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
      t.text :report_csv

      t.timestamps
    end
  end
end

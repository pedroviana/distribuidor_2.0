class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :company
      t.string :email
      t.string :cep
      t.string :address
      t.string :state
      t.string :city
      t.string :cel
      t.string :smartphone
      t.string :job
      t.string :complement
      t.string :number
      t.boolean :report_not_done, :default => false
      
      t.boolean :image_usage
      t.boolean :sms_alert
      t.boolean :email_alert

      t.timestamps
    end
  end
end

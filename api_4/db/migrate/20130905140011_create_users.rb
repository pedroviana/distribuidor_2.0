class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :null => false
      t.string :name, :null => false
      t.string :company, :null => false
      t.string :position
      t.string :address
      t.string :address_number
      t.string :complement
      t.string :cep
      t.string :state
      t.string :city
      t.string :celnumber
      t.string :is_smartphone
      t.string :image_usage
      t.string :sms_usage
      t.string :email_usage
      
      t.boolean :completed, :default => false, :null => false

      t.timestamps
    end
  end
end

class UserEventConfirmation < ActiveRecord::Base
  attr_accessible :address, :cellnumber, :cep, :city, :complement, :email_usage, :function, :image_usage, :number, :smartphone, :sms_usage, :state,
                  :id, :user_event_id, :report_csv, :created_at, :updated_at, :qr_sent_at, :qr_path, :midia_attachment, :report_csv, :midia_attachment, :server_id
  attr_accessor :midia_attachment, :report_csv
  
  belongs_to :user_event
  has_one :report_relationship, :class_name => "Report", :foreign_key => 'user_event_confirmation_id', :dependent => :destroy
  
  before_save :set_user_attributes

  after_create :create_midia_attachment
  
  def set_user_attributes
    mappings = {"position" => "job", "address_number" => "number", "is_smartphone" => "smartphone", "sms_usage" => "sms_alert", "email_usage" => "email_alert", "celnumber" => "cel"}
    user_hash = user_event.user_relationship.attributes
    new_user_hash = Hash[user_hash.map {|k, v| [mappings[k] || k, v] }]
    new_user_hash.delete('id')
    user_event.user_relationship.update_attributes(new_user_hash)
  end
  
  def create_midia_attachment
    return true if midia_attachment.nil?
    
    prefix_url = Settings.find_by_key('K_PREFIX_URL').value
    url = "#{prefix_url}#{midia_attachment['file_url']}"
    t=Time.now
    temp_path = "temp_attachment_#{t.year}_#{t.month}_#{t.day}_#{t.hour}_#{t.min}_#{t.sec}.csv"
    file_success = true
    begin
      File.open(temp_path,"w") do |f|
        f.write open(url).read.force_encoding('UTF-8')
      end 
    rescue Exception => e
      file_success = false
    end

    keys_to_delete = ['file_file_name', 'file_content_type', 'file_file_size', 'file_updated_at', 'file_url', 'id']
    keys_to_delete.each{|key| midia_attachment.delete(key)}
    
    midia_attachment.merge!(:what => 'habitos_de_midia')
#    midia_attachment.merge!(:user_event_id => user_event.code || nil)

    if file_success
      file = File.new(temp_path)
      midia_attachment.merge!(:file => file)
      if user_event.reports.create(midia_attachment)
#        user_event.user_relationship.update_next_status
      end
    end
  end
end

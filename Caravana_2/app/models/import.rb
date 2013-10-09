class Import < ActiveRecord::Base
  belongs_to :admin_user
  attr_accessible :sync, :admin_user_id, :parsed
  has_many :events, :dependent => :destroy
  
	has_attached_file :sync, :url => "/:attachment/:id/:filename", :path => ":rails_root/public/:attachment/:id/:filename"
	
#	validates_uniqueness_of :sync_file_name
  
  def parse_file
    return true if parsed
    
    file, json = nil

    begin
      file = File.open(sync.path)
    rescue  Exception => e
      errors.add :sync, "Problema ao abrir o arquivo"
      return false
    end
    
    begin
      json = JSON.parse(file.read)
    rescue  Exception => e
      errors.add :sync, "Problema ao ler o arquivo"
      return false
    end

    a = false
    json.each do |e|
      Import.transaction do
        Event.transaction do

          begin
            e.delete('latitude')
            e.delete('longitude')
            e['server_id'] = e['id']
            e.delete('id')

            if (event = Event.find_by_server_id(e['server_id']) rescue false ) 
              success = event.update_attributes(e)
            else
              event   = events.create(e)
              success = !event.new_record?
              #raise event.inspect
            end

            if success
              update_attribute(:parsed, true)
            else
              raise event.errors.messages.inspect
            end
          rescue Exception => e
            raise e.inspect
            #return false
          end
        end
      end      
      #return true
    end
  end
end
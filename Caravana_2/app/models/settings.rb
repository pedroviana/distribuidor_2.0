class Settings < ActiveRecord::Base
  attr_accessible :ative, :key, :value
  
  validates_uniqueness_of :key
  
  before_create do
    self.ative = true unless value.nil?
  end
end

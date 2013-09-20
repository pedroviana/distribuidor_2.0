class Version < ActiveRecord::Base
  attr_accessible :children
  serialize :children, Array

  after_save :restore_children

  def recreating_item?
    if item
      item.versions[-1].try(:event) == 'create' && item.versions[-2].try(:event) == 'destroy'
    end
  end

  def restore_children
    if children && recreating_item?
      children.each do |model_name|
        records = Version.where(:item_type => model_name.classify)

        records.each do |ver|
          ver.reify.save! if ver.event == 'destroy' && ver.created_at > 20.seconds.ago
        end
      end
    end
  end
end
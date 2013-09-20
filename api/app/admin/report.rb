ActiveAdmin.register Report do
  menu if: proc { current_admin_user.can_access?( I18n.t('activerecord.models.report') ) rescue false }, label: 'Convites/Confirmados', parent: 'Relatório', priority: 4

  batch_action :destroy, false

  scope :convites  
  scope :confirmados
  
  filter :event
  filter :admin_user
  filter :user
  filter :created_at
  
  index do
    selectable_column
    column :admin_user
    column :schema_description
    column :user
    column :created_at
  end
  
  controller do
    def action_methods
      super - ['edit', 'destroy', 'new', '']
    end
  end
end

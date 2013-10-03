# encoding: UTF-8

class Report < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :user_event
  has_one :event, through: :user_event
  has_one :user, through: :user_event
  
  attr_accessible *column_names
  
  scope :presences, -> {where(schema: AppSettings.k_presence_report_schema)}
  scope :invites, -> {where(schema: AppSettings.k_invite_report_schema)}
  scope :convites, -> {invites}
  scope :confirmados, -> {presences}
  
  def schema_description
    if schema == AppSettings.k_presence_report_schema
      "Presença"
    elsif schema == AppSettings.k_invite_report_schema
      'Convite'
    else
      'Não identificado'
    end
  end
end

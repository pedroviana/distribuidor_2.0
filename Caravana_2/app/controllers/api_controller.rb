# encoding: UTF-8

class ApiController < ApplicationController
	# Person requests

  def pending_users
    users = Event.pending_users(params[:event_id])
    render :text => users.to_json(:methods => [:info_completed_json, :what_name])
  end

  def events
    render :text => Event.where("datetime > ?", Time.now.beginning_of_day - 7.days ).to_json(:only => [:title, :address, :id])
  end

  def check_email
    user = User.find_by_email( params[:email] ) rescue nil
    if user
      user_event = UserEvent.find_by_user_id_and_event_id(user.code , params[:event_id] )
      if user_event
        if params[:from_qr_code].to_s == '1'
          user_event.update_attributes(qr_code_scanned: true, email_search: false)
        else
          user_event.update_attributes(qr_code_scanned: false, email_search: true)          
        end
      end

      #render :text => user_event.to_json(:methods => [:info_completed], :only => [], :include => [:user_relationship => {:only => [:email, :name, :company, :job, :id], :methods => :what_name } ] )
      render :text => user_event.to_json(:methods => [:info_completed], :only => [], :include => [:user_relationship => { :methods => :what_name } ] ) and return
    else
      render :text => "-1" and return
    end
  end
  
	def create_user
	  user_params = JSON.parse(params[:user])
	  user_id = user_params['id'] rescue nil
	  if user_id
	    user_params.delete('id')
	    user = User.find(user_id)
	    user.update_attributes( user_params )
    else
		  user = User.new(user_params)
    end

		if user.save
			status = user.code
		else
		  errors = user.errors.messages.to_a.flatten
      if errors.include?(:email)
        status = -2
      else
			  status = -1
      end
		end

		render :text => { :status => status, :messages => user.errors.messages.values.flatten }.to_json
	end

	# Reports
	def send_report
		user_event = UserEvent.find_by_user_id_and_event_id(params[:user_id], params[:event_id])
		status = 0
		if user_event and user_event.reports.build(:file => params[:file], :what => params[:what]).save
			status = 1
		end

		render :text => {:status => status, :what => user_event.user_relationship.next_status_string }.to_json
	end

	# Insert the user to the final position of the queue
=begin
	def insert_test_drive_queue
		user = User.find(params[:user_id]) rescue nil
		status = 0
		if user
			if user.driver_queue.update_attributes(:truck => params[:truck], :can_view => params[:can_view])
				status = 1
			elsif user.driver_queue
				status = 2
			end
		end

		render :text => status.to_json
	end
=end

	def no_show
		user = User.find(params[:user_id]) rescue nil
		if user
			if !user.report_not_done and user.update_attribute(:report_not_done, true)
				status = 1
			else
				status = 2
			end
		else
			status = 0
		end

		render :text => status.to_json
	end

	def list_midia_reports
    users = Event.pending_users_only_report(params[:event_id])
    render :text => users.to_json(:only => [:id, :name], :methods => [:info_completed_json, :what_name])
	end

=begin
	def list_test_drive
		render :text => DriverQueue.where("can_view = ? AND no_show = ?", true, false).order('updated_at ASC').map(&:user).to_json(:only => [:id, :name], :methods => [:truck_name])
	end

	# Premiation
	def list_premiation
		render :text => Premiation.where("delivered = ? AND can_view = ?", false, true).map(&:user).to_json(:only => [:id, :name])
	end

	def receive_premiation
		user = User.find(params[:user_id])
		status = 0
		if user and user.premiation.update_attribute(:delivered, true)
			status = 1
		end

		render :text => status.to_json
	end

	def can_receive_premiation
		user 		= User.find(params[:user_id])
		status 	= 0

		if user
			unless user.premiation.delivered
				status = 1	
			end
		end

		render :text => status.to_json
	end
=end
end

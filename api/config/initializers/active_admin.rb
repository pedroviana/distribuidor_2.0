ActiveAdmin.setup do |config|
  class MyFooter < ActiveAdmin::Component
    def build
      super(id: "footer")
      para "Copyright #{Date.today.year} DNA Digital".html_safe
    end
  end
  
  config.view_factory.footer = MyFooter
  
  config.allow_comments = false  
  
  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "Distribuidor 2.0"

  # Set the link url for the title. For example, to take
  # users to your main site. Defaults to no link.
  #
  # config.site_title_link = "/"

  # Set an optional image to be displayed for the header
  # instead of a string (overrides :site_title)
  #
  # Note: Recommended image height is 21px to properly fit in the header
  #
  # config.site_title_image = "/images/logo.png"

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to.
  #
  # eg:
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  #
  # Default:
  # config.default_namespace = :admin
  #
  # You can customize the settings for each namespace by using
  # a namespace block. For example, to change the site title
  # within a namespace:
  #
  #   config.namespace :admin do |admin|
  #     admin.site_title = "Custom Admin Title"
  #   end
  #
  # This will ONLY change the title for the admin section. Other
  # namespaces will continue to use the main "site_title" configuration.

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the controller.
  config.authentication_method = :authenticate_admin_user!


  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # to return the currently logged in user.
  config.current_user_method = :current_admin_user


  # == Logging Out
  #
  # Active Admin displays a logout link on each screen. These
  # settings configure the location and method used for the link.
  #
  # This setting changes the path where the link points to. If it's
  # a string, the strings is used as the path. If it's a Symbol, we
  # will call the method to return the path.
  #
  # Default:
  config.logout_link_path = :destroy_admin_user_session_path

  # This setting changes the http method used when rendering the
  # link. For example :get, :delete, :put, etc..
  #
  # Default:
  # config.logout_link_method = :get


  # == Root
  #
  # Set the action to call for the root path. You can set different
  # roots for each namespace.
  #
  # Default:
  # config.root_to = 'dashboard#index'


  # == Admin Comments
  #
  # This allows your users to comment on any resource registered with Active Admin.
  #
  # You can completely disable comments:
  # config.allow_comments = false
  #
  # You can disable the menu item for the comments index page:
  # config.show_comments_in_menu = false
  #
  # You can change the name under which comments are registered:
  # config.comments_registration_name = 'AdminComment'


  # == Batch Actions
  #
  # Enable and disable Batch Actions
  #
  config.batch_actions = true


  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources and pages from here.
  #
  # config.before_filter :do_something_awesome

  config.before_filter do |controller|
    return true if controller.controller_name == 'sessions' and ( controller.action_name == 'create' or controller.action_name == 'new' )

    if current_admin_user.nil?
      redirect_to new_admin_user_session_path and return
    end

    return unless current_admin_user

=begin
    if current_admin_user.should_change_password and !controller.params.include?(:confirmation_token)
      if controller.controller_name == 'admin_users' and controller.action_name == 'change_password'
        # true if the user is trying to update their password HTML
        return true
      elsif controller.controller_name == 'admin_users' and controller.action_name == 'update' and controller.params.include?(:change_password)
        # true if the user is trying to update their password HTML
        return true
      end
      # user still needs to change their password
      redirect_to change_password_admin_admin_user_path(current_admin_user), :alert => 'Você precisa definir uma nova senha.' and return
    elsif current_admin_user.ios?
      # ios user dont have access to the panel
      redirect_to static_index_path and return
    else
      #proceed access
    end
=end

    model_name            = controller.controller_name.to_s.singularize
    translated_model_name = I18n.t("activerecord.models.#{model_name}")
    
    return true if controller.controller_name == 'admin_users' and controller.action_name == 'password'
    
    return true if ( current_admin_user.can_access?( I18n.t("activerecord.models.#{model_name}") ) rescue false )

    return true if ( translated_model_name == 'Painel'  )
=begin
  begin
    redirect_to :back, :alert => 'Accesso negado.'
  rescue ActionController::RedirectBackError
    redirect_to root_path, :alert => 'Accesso negado.'
  end
=end

    # true if the Area is not created in DB
    area = Area.find_by_title(translated_model_name)
    unless area.nil?
      # root_path if the user dont have the access of the area

      if controller.action_name == 'password' || (controller.controller_name == 'admin_users' and controller.action_name == 'update') || (controller.controller_name == 'admin_users' and controller.action_name == 'update_my_password')
        return true
      end
#      raise translated_model_name.inspect
#      raise current_admin_user.can_access?(translated_model_name).inspect

      unless (current_admin_user.can_access?(translated_model_name) rescue false)
        redirect_to root_path and return
      end
      
      redirect_to current_admin_user.user_type_areas.first.url rescue root_path and return
    end
  end


  
  
  # == Setting a Favicon
  #
  # config.favicon = '/assets/favicon.ico'


  # == Register Stylesheets & Javascripts
  #
  # We recommend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  #   config.register_stylesheet 'my_stylesheet.css'
  #
  # You can provide an options hash for more control, which is passed along to stylesheet_link_tag():
  #   config.register_stylesheet 'my_print_stylesheet.css', :media => :print
  #
  # To load a javascript file:
  #   config.register_javascript 'my_javascript.js'


  # == CSV options
  #
  # Set the CSV builder separator
  # config.csv_options = { :col_sep => ';' }
  #
  # Force the use of quotes
  # config.csv_options = { :force_quotes => true }


  # == Menu System
  #
  # You can add a navigation menu to be used in your application, or configure a provided menu
  #
  # To change the default utility navigation to show a link to your website & a logout btn
  #
  #   config.namespace :admin do |admin|
  #     admin.build_menu :utility_navigation do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #       admin.add_logout_button_to_menu menu
  #     end
  #   end
  #
  # If you wanted to add a static menu item to the default menu provided:
  #
  #   config.namespace :admin do |admin|
  #     admin.build_menu :default do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #     end
  #   end


  # == Download Links
  #
  # You can disable download links on resource listing pages,
  # or customize the formats shown per namespace/globally
  #
  # To disable/customize for the :admin namespace:
  #
  #   config.namespace :admin do |admin|
  #
  #     # Disable the links entirely
  #     admin.download_links = false
  #
  #     # Only show XML & PDF options
  #     admin.download_links = [:xml, :pdf]
  #
  #   end


  # == Pagination
  #
  # Pagination is enabled by default for all resources.
  # You can control the default per page count for all resources here.
  #
  # config.default_per_page = 30


  # == Filters
  #
  # By default the index screen includes a “Filters” sidebar on the right
  # hand side with a filter for each attribute of the registered model.
  # You can enable or disable them for all resources here.
  #
  # config.filters = true

end

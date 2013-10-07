# encoding: UTF-8

ActiveAdmin.register_page "Dashboard" do
  menu :label => proc{ I18n.t("active_admin.dashboard") }, priority: 1

  action_item do
    link_to "Trocar Senha", edit_admin_minha_contum_path(current_admin_user)
  end

  content :title => proc{ I18n.t("active_admin.dashboard") } do
=begin
    columns do
      column do
        panel "Recent Orders" do
          table_for Order.complete.order('id desc').limit(10) do
            column("State")   {|order| status_tag(order.state)                                    } 
            column("Customer"){|order| link_to(order.user.email, admin_customer_path(order.user)) } 
            column("Total")   {|order| number_to_currency order.total_price                       } 
          end
        end
      end

      column do
        panel "Recent Customers" do
          table_for User.order('id desc').limit(10).each do |customer|
            column(:email)    {|customer| link_to(customer.email, admin_customer_path(customer)) }
          end
        end
      end

    end # columns

    columns do

      column do
        panel "ActiveAdmin Demo" do
          div do
            render('/admin/sidebar_links', :model => 'dashboards')
          end

          div do
            br
            text_node %{<iframe src="https://rpm.newrelic.com/public/charts/6VooNO2hKWB" width="500" height="300" scrolling="no" frameborder="no"></iframe>}.html_safe
          end
        end
      end
=end
  end 
end

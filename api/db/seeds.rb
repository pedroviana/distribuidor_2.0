# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

    admin_user_types = ["Administrador", "Criador de Eventos", "Criador de Convites", "Sincronizador de Eventos"]
    admin_user_types.each{ |admin_user_type| AdminUserType.create(title: admin_user_type)  }
    
    areas = ["Usuário", "Evento", "Cliente", "Relatório", 'Tipo de Usuário', 'Relatório', 'Logs']
    areas.each{ |area| Area.create(title: area)  }
    
    adm = AdminUserType.first
    Area.all.each{|area| adm.admin_user_type_areas.create(:area_id => area.code )  }
    
    
class PaperTrailModel
  def self.paper_trail_user( p )
    AdminUser.find(p.whodunnit) rescue p.whodunnit
  end
  
  def self.audit_action(p)
    case p
    when 'update'
      'Atualizou'
    when 'create'
      'Criou'
    when 'destroy'
      'Deletou'
    else
      p
    end
  end
  
  def self.correct_value(class_name, key, value)
    #a = [class_name, key, value]

    class_name.downcase!

    return 'Nada' unless value

    if class_name
      kinds = I18n.t("activerecord.type_attributes.#{class_name}.#{key}").split('|')

#      begin
        if kinds.count == 2
          case kinds.first
          when 'Belong'
            if value
              return eval("#{kinds.last}.find(#{value}).name") rescue 'Não encontrado'
            else
              return value
            end
          when 'String'
            if kinds.last == 'Method'
              return eval("#{class_name.capitalize}.description_of_K('#{value}')")
            end

            return val
          end
        elsif kinds.count == 3
          if value
            if kinds.last == 'Split'
              value = [value.split(',')].flatten.compact
            end

            objects = eval("#{kinds[1]}.find(#{[value].flatten})") rescue []

            string_response = []

            objects.each do |x|
              string_response << x.title
            end

            string_response = "Não encontrado" if string_response.empty?

            return ( string_response.join(',') rescue string_response ) 
          else
            return value
          end          
        elsif kinds.count > 2
          case kinds.first
          when 'Belong'
            if value
              object = eval("#{kinds[1]}.find(#{value})")
              if kinds[2] == 'Belong'
                associated_attribute_name = "#{kinds.last}_id".downcase
                associated_id = object.send("#{associated_attribute_name}")
                return eval("#{kinds.last}.find(#{associated_id}).title") rescue 'Não encontrado'
              else
                return object.title rescue 'Não encontrado'
              end

              return 'Não encontrado'
            else
              return value
            end
          end
        else
          case kinds.first
          when 'Boolean'

            if value.is_a?(TrueClass)
              value = '1'
            elsif value.is_a?(FalseClass)
              value = '0'
            elsif value == 'true'
              value = '1'
            elsif value == 'false'
              value = '0'
            end

            if value == '1'
              return 'Sim'
            elsif value == '0'
              return 'Não'
            else
              return 'Nada'
            end
          when 'Date', 'DateTime', 'Time'
            #return value.to_datetime.strftime("%d/%m/%Y %H:%m")
            return Time.zone.parse(value.to_s).strftime("%d/%m/%Y %H:%m")
          when 'String'
            return value
          end
        end
   #   rescue Exception => e
  #      puts e.inspect
  #    end
    end
  end
end
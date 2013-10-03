# encoding: UTF-8

require 'csv'
require 'qrcode_lib'

class UserEventConfirmation < ActiveRecord::Base
  belongs_to :user_event
  has_one :user, through: :user_event
  has_one :event, through: :user_event
  has_one :midia_attachment

  #attr_accessible *column_names, :blank_midia_attachment

#  validates_presence_of :function, :address, :number, :complement, :cep, :state, :city, :celnumber, :smartphone, :image_usage, :sms_usage, :email_usage, :unless => valid_presence.nil?
#  attr_accessor :valid_presence
  attr_accessor :blank_midia_attachment
  
  before_create do |u|
    u.check_booleans
    u.update_user_attributes
    u.generate_report_csv unless u.blank_midia?
  end

  attr_accessor :name, :company, :function, :address, :number, :complement, :cep, :state, :city, :celnumber, :smartphone, :image_usage, :sms_usage, :email_usage,
                # csv accessors
                :le_revista, :revistas, :outra_revista,
                :le_jornal, :jornais,
                :ouve_radio, :radios, :tipo_musica, :outra_radio, :tipo_musica_other,
                :assisti_tv, :frequencia_tv, :canais, :canais_fechados, :outros_canais, :programas_preferidos, :outro_preferido,
                :envia_recebe_sms,
                :usa_internet, :tipo_internet, :frequencia_internet, :locais_internet, :o_que_ve_internet, :outros_sites_noticias, :outros_sites,
                :acessa_redes_sociais, :quais_redes_sociais, :quais_blogs, :outras_redes,
                :visita_site_especializado, :sites_especializados, :outro_site_especializado,
                # newspapers
                :jornais_acres,:jornais_acres_other,
                :jornais_alagoass,:jornais_alagoass_other,
                :jornais_amazonass,:jornais_amazonass_other, 		
                :jornais_bahias,:jornais_bahias_other, 			
                :jornais_cears,:jornais_cears_other,			
                :jornais_distrito_federals,:jornais_distrito_federals_other, 
                :jornais_esprito_santos,:jornais_esprito_santos_other, 	
                :jornais_goiss,:jornais_goiss_other, 			
                :jornais_goinias,:jornais_goinias_other, 			
                :jornais_maranhos,:jornais_maranhos_other, 		
                :jornais_mato_grosso_do_suls,:jornais_mato_grosso_do_suls_other,
                :jornais_minas_geraiss,:jornais_minas_geraiss_other, 	
                :jornais_parans,:jornais_parans_other, 			
                :jornais_parabas,:jornais_parabas_other, 			
                :jornais_pars,:jornais_pars_other, 			
                :jornais_pernambucos,:jornais_pernambucos_other, 		
                :jornais_piaus,:jornais_piaus_other, 			
                :jornais_rio_grande_do_nortes,:jornais_rio_grande_do_nortes_other,
                :jornais_rio_grande_do_suls,:jornais_rio_grande_do_suls_other,
                :jornais_rio_de_janeiros,:jornais_rio_de_janeiros_other,	
                :jornais_rondnias,:jornais_rondnias_other, 		
                :jornais_roraimas,:jornais_roraimas_other, 		
                :jornais_santa_catarinas,:jornais_santa_catarinas_other, 	
                :jornais_so_paulos,:jornais_so_paulos_other,		
                :jornais_sergipes,:jornais_sergipes_other

  def check_booleans
    smartphone_b  = smartphone.to_s   == "1" ? true : false #rescue false
    image_usage_b = image_usage.to_s  == "1" ? true : false #rescue false
    sms_usage_b   = sms_usage.to_s    == "1" ? true : false #rescue false
    email_usage_b = email_usage.to_s  == "1" ? true : false #rescue false
    
    self.smartphone   = smartphone_b
    self.image_usage  = image_usage_b
    self.sms_usage    = sms_usage_b
    self.email_usage  = email_usage_b
  end

  def update_user_attributes
    user.attributes = {
      is_smartphone: smartphone, 
      image_usage: image_usage, 
      sms_usage: sms_usage, 
      email_usage: email_usage,
      name: name, 
      company: company, 
      position: function, 
      address: address, 
      address_number: number, 
      complement: complement, 
      cep: cep, 
      state: state, 
      city: city, 
      celnumber: celnumber
    }
  end

  def send_qr
    write_attribute(:qr_path, LibQRCode.generate_qrcode(user.email, {:size => 4}))
    if qr_path.is_a?(String) and qr_sent_at.nil?
      begin
        UserEventConfirmationMailer.send_qr(self).deliver 
        update_attribute(:qr_sent_at, Time.now)
      rescue Exception => e
        update_attribute(:qr_sent_at, nil)        
      end
    end
  end

  def token
    user_event.token
  end

  def other_keys
    #%{Libera uso de imagem?/Libera envio de SMS?/Libera envio de e-mails?/Lê revistas?/Quais?/Outras/Lê Jornais?/Quais?/Acre/Outro/Alagoas/Outro/Amazonas/Outro/Bahia/Outro/Ceará/Outro/Distrito Federal/Outro/Espírito Santo/Outro/Goiás/Outro/Goiânia/Outro/Maranhão/Outro/Mato Grosso do Sul/Outro/Minas Gerais/Outro/Paraná/Outro/Paraíba/Outro/Pará/Outro/Pernambuco/Outro/Piauí/Outro/Rio Grande do Norte/Outro/Rio Grande do Sul/Outro/Rio De Janeiro/Outro/Rondônia/Outro/Roraima/Outro/Santa Catarina/Outro/São Paulo/Outro/Sergipe/Outro/Ouve Rádio?/O que ouve no rádio?/Que tipo de música ouve?/Outro/Assiste TV?/Com qual frequência?/Quais canais gosta de ver na TV?/Outros/Qual(is) o(s) programa(s) preferido(s)?/Envia ou Recebe SMS?/Usa internet?/Com qual frequência usa a internet?/Locais onde acessa a internet:/O que costuma olhar na internet?/Quais redes sociais acessa?/Blogs/Outros/Visita algum site especializado em caminhões?/Quais sites?/Outro?}.split('/')
    %{Lê revistas?/Quais?/Outras/Lê Jornais?/Quais?/Acre/Outro/Alagoas/Outro/Amazonas/Outro/Bahia/Outro/Ceará/Outro/Distrito Federal/Outro/Espírito Santo/Outro/Goiás/Outro/Goiânia/Outro/Maranhão/Outro/Mato Grosso do Sul/Outro/Minas Gerais/Outro/Paraná/Outro/Paraíba/Outro/Pará/Outro/Pernambuco/Outro/Piauí/Outro/Rio Grande do Norte/Outro/Rio Grande do Sul/Outro/Rio De Janeiro/Outro/Rondônia/Outro/Roraima/Outro/Santa Catarina/Outro/São Paulo/Outro/Sergipe/Outro/Ouve Rádio?/O que ouve no rádio?/Que tipo de música ouve?/Outro/Assiste TV?/Com qual frequência?/Quais canais gosta de ver na TV?/Outros/Qual(is) o(s) programa(s) preferido(s)?/Envia ou Recebe SMS?/Usa internet?/Com qual frequência usa a internet?/Locais onde acessa a internet:/O que costuma olhar na internet?/Quais redes sociais acessa?/Blogs/Outros/Visita algum site especializado em caminhões?/Quais sites?/Outro?}.split('/')
  end
  
  def csv_methods
    #[image_usage, sms_usage, email_usage, le_revista, revistas, outra_revista, le_jornal, jornais,
    [le_revista, revistas, outra_revista, le_jornal, jornais,
      jornais_acres,                jornais_acres_other,
      jornais_alagoass,             jornais_alagoass_other,
      jornais_amazonass,            jornais_amazonass_other, 		
      jornais_bahias,               jornais_bahias_other, 			
      jornais_cears,                jornais_cears_other,			
      jornais_distrito_federals,    jornais_distrito_federals_other, 
      jornais_esprito_santos,       jornais_esprito_santos_other, 	
      jornais_goiss,                jornais_goiss_other, 			
      jornais_goinias,              jornais_goinias_other, 			
      jornais_maranhos,             jornais_maranhos_other, 		
      jornais_mato_grosso_do_suls,  jornais_mato_grosso_do_suls_other,
      jornais_minas_geraiss,        jornais_minas_geraiss_other, 	
      jornais_parans,               jornais_parans_other, 			
      jornais_parabas,              jornais_parabas_other, 			
      jornais_pars,                 jornais_pars_other, 			
      jornais_pernambucos,          jornais_pernambucos_other, 		
      jornais_piaus,                jornais_piaus_other, 			
      jornais_rio_grande_do_nortes, jornais_rio_grande_do_nortes_other,
      jornais_rio_grande_do_suls,   jornais_rio_grande_do_suls_other,
      jornais_rio_de_janeiros,      jornais_rio_de_janeiros_other,	
      jornais_rondnias,             jornais_rondnias_other, 		
      jornais_roraimas,             jornais_roraimas_other, 		
      jornais_santa_catarinas,      jornais_santa_catarinas_other, 	
      jornais_so_paulos,            jornais_so_paulos_other,		
      jornais_sergipes,             jornais_sergipes_other,
      ouve_radio, radios, tipo_musica, outra_radio, assisti_tv, frequencia_tv, canais, outros_canais, programas_preferidos, envia_recebe_sms, usa_internet, frequencia_internet, locais_internet, o_que_ve_internet, quais_redes_sociais, quais_blogs, outras_redes, visita_site_especializado, sites_especializados, outro_site_especializado
    ]
  end
  
  def generate_report_csv
    #build_midia_attachment
    
    file_path = "temp_midia_survey_#{self.token}"
    file = Tempfile.new(file_path)
    
    user_header = other_keys

    CSV.open( file, 'w' ) do |writer|
      writer<<other_keys
      #writer<<'\n'
      v = csv_methods.map! do |x|
        if x.is_a?(Array)
          [x.reject{ |c| c.empty? }].flatten.join(',')
        elsif boolean?(x)
          x ? 'Sim' : 'Não'
#        elsif integer_boolean?(p)
#          x.to_i == 1 ? 'Sim' : 'Não'
        else
          x
        end
      end
      
      values = v.flatten
      writer << values
    end
    
    build_midia_attachment(file: file)
  end
  
  def code
    read_attribute('id')
  end

  def name
    user.name
  end
  
  def company
    user.company
  end
  
  def boolean?(p)
    p.is_a?(TrueClass) || p.is_a?(FalseClass)
  end
  
  def integer_boolean?(p)
    p.to_i.is_a?(Integer)
  end
  
  def blank_midia?
    blank_midia_attachment.to_s.to_i == 1
  end
  
  class << self
    def start_invites_schedule
=begin
			AppSettings.mail_schedules.every '5m' do
	  		pending_confirmations = UserEventConfirmation.where("qr_sent_at IS NULL")
	  		pending_confirmations.each do |pending_confirmation|
	  		  pending_confirmation.send_qr
  		  end
	  	end
=end
    end
    
    def magazines
      %{A Granja/Arquitetura e Construção/Autoesporte/Autoshow/Caras/Carga Pesada/Carro Estéreo/Carta Capital/Casa Jardim/Contigo/Época/Exame/Faço Parte/Giro do Caminhoneiro/Globo Rural/Isto É/Manchete/Motoshow/Mundo Estranho/Na Boléia/Nova Escola/O Caminhoneiro/O Carreteiro/O Mecânico/Oficina Mecânica/Pequenas Empresas e Grandes Negócios/Perfil/Placar/Playboy/Quatro Rodas/Quem/Sebrae/Seleções/Sexy/Siga Bem Caminhoneiro/Transpomagazine/Transporte Moderno/Transporte Mundial/Veja/Você SA/Vogue/Outras}.split('/')
    end
    
    def musics
      %{Sertanejo/Variadas/Rock/Forró/Religiosas/Pagode/MPB/Romântica/Outro}.split('/')
    end
    
    # =========================
    # Jornals
    def newspapers
      %{Qualquer jornal Regional/Acre/Alagoas/Amazonas/Bahia/Ceará/Distrito Federal/Espírito Santo/Goiás/Goiânia/Maranhão/Mato Grosso do Sul/Minas Gerais/Paraná/Paraíba/Pernambuco/Piauí/Rio Grande do Norte/Rio Grande do Sul/Rio De Janeiro/Rondônia/Roraima/Santa Catarina/São Paulo/Sergipe}.split('/')
    end
    
    def acre_newspapers
      %{A Gazeta}.split('/')
    end
    
    def alagoas_newspapers
      %{O Jornal/A Gazeta de Alagoas}.split('/')
    end
    
    def amazonas_newspapers
      %{A Cidade/A Crítica/Gazeta Mercantil}.split('/')
    end
    
    def bahia_newspapers
      %{A Região/A Tarde/Correio da Bahia/Gazeta Mercantil/Jornais do Brasil/Jornais Portugueses/Jornal Cidade Baixa/Jornal Grapiúna/Jornal Proibido/Tribuna da Bahia}.split('/')
    end
    
    def ceara_newspapers
      %{Diário do Nordeste/Gazeta Mercantil/O Povo}.split('/')
    end
    
    def df_newspapers
      %{Correio Brasiliense/Correio/Oficial/Gazeta Marcantil/Jornal de Brasília}.split('/')
    end
    
    def espirito_santo_newspapers
      %{A Gazeta/A Tribuna/Jornal ES Hoje/Século Diário/Folha do Litoral/Jornal Entrevista/Jornal Vox Populi/Aqui ES/Jornal de Fato/Diário do Nordeste}.split('/')
    end
    
    def goias_newspapers
      %{Correio Brasiliense/Correio/Oficial/Gazeta Marcantil/Jornal de Brasília}.split('/')
    end
    
    def goiania_newspapers
      %{O Popular}.split('/')
    end
    
    def maranhao_newspapers
      %{Folha de Maranhão/Jornal Pequeno/O Estado do Maranhão/O Imparcial/O Progresso}.split('/')
    end
    
    def mato_grosso_do_sul_newspapers
      %{Gazeta Mercantil/Serra Nossa}.split('/')
    end
    
    def minas_gerais_newspapers
      %{Aqui/Diário Oficial de Minas Gerais/Estado de Minas Gerais/Estado do Triângulo/Folha da Manhã/Gazeta Mercantil/Jornal de Uberaba/Jornal do Pontal/Jornal Hoje em Dia/O Debate/O Sul de Minas/O Tempo/Pontal do Triângulo/Super Notícias/Tribuna de Lavras/Tribuna de Minas}.split('/')
    end
    

    def parana_newspapers
      %{Folha de Londrina/Gazeta do Paraná/Gazeta do Povo/Gazeta Mercantil/Hoje/Induscom/Jornal 1º Linha/Jornal Caiçara/Jornal da Manhã/Jornal do Estado/Jornal do Oeste/Jornal União/O Paraná/Paraná Online}.split('/')
    end

    def paraiba_newspapers
      %{Correio da Paraíba/Diário da Borborema/Jornal da Paraíba/O Norte}.split('/')
    end

    def para_newspapers
      %{Gazeta Mercantil/O Liberal}.split('/')
    end

    def pernambuco_newspapers
      %{A FolhaNet/Diário de Pernambuco/Folha de Pernambuco/Jornal do Comercio}.split('/')
    end

    def piaui_newspapers
      %{Meio Norte}.split('/')
    end

    def rio_grande_do_norte_newspapers
      %{Diário de Natal/Jornal de Hoje/Jornal do Centro de Ciências/Tribuna do Norte/Voz de Natal}.split('/')
    end

    def rio_grande_do_sul_newspapers
      %{A Platéia/A Razão/Bom Dia/Correio do Povo/Correio Livre/Diário Popular/Folha da Cidade/Gazeta do Sul/Gazeta Mercantil/Jornal do Comércio/Jornal NH/Mundo Jovem/O Florense/O Nacional/Pioneiro/Riovale Jornal/Serra Nossa/Visão Regional/Zero Hora}.split('/')
    end    

    def rio_de_janeiro_newspapers
      %{Aqui/Folha da Serra/Folha de Niterói/Folha Dirigida/Gazeta Mercantil/Inverta/Jornal Alef/Jornal do Brasil/Jornal do Comércio/Jornal do Meio Ambiente/Lance!/Monitor Mercantil/Niterói em Outras Palavras/O Dia/O Diário/O Globo/O São Gonçalo/Samaruama}.split('/')
    end
    
    def rondonia_newspapers
      %{Diário da Amazônia/Estadão do Norte}.split('/')
    end
    
    def roraima_newspapers
      %{Folha de Boa Vista}.split('/')
    end
    
    def santa_catarina_newspapers
      %{A Notícia/A Tribuna/Correio Lageado/Diário Catarinense/Gazeta Mercantil/Jornal de Laguna/Jornal de Lajes/Jornal de Santa Catarina/Jornal do povo/O Correio/O Momento}.split('/')
    end
    
    def sao_paulo_newspapers
      %{A Cidade/A Tribuna/Avaré News/Bragança Jornal Diário/Cidade Itapira/Classíndico/Correio Popular/Cruzeiro do Sul/Diário da Região/Diário de Marília/Diário de Moji das Cruzes/Diário de Sorocaba/Diário do ABC/Diário do Grande ABC/Diário do Povo/Estadão/Estado de São Paulo/Folha da Região de Araçatuba/Folha da Tarde/Folha de Cerquilho/Folha de Cesário Lange/Folha de Piraju/Folha de São Paulo/Folha do Sul/Gazeta Esportiva/Gazeta Mercantil/Hora do Povo/Imparcial/Imprensa Oficial do Estado de São Paulo/Jornal da Cidade/Jornal da Tarde/Jornal de Hoje/Jornal de Jundiaí/Jornal do Cruzeiro do Sul/Jornal do Dia/Jornal do Parabrisa/Jornal do Povo/Jornal Expresso/Jornal Integração/Jornal Nova Odessa/Notícias Populares/O Berro do Coronel/O Vale/Olhão/Primeira Mão/Segunda Mão/Todo Dia/Vale Paraibano/Valor Econômico/Valor On Line}.split('/')
    end
    
    def sergipe_newspapers
      %{Correio de Sergipe/CINFORM/Gazeta de Sergipe/Jornal da Cidade/Sergipe Hoje}.split('/')
    end  
    # Jornals
    # =========================
    
    def radios
      ["Música",
      "Esporte / Jogos",
      "Programas de Entreternimento",
      "Notícias",
      "Trânsito",
      "Outros"]
    end
    
    def tv_frequencies
      ["Todo Dia",
      "Entre 2 e 6 dias por semana",
      "Uma vez por semana"]
    end
    
    def channels
      ["Globo",
      "Band",
      "SBT",
      "Rede TV",
      "Record",
      "Canais Fechados",
      "Outros"]
    end
    
    def programs
      %{Notícias/Esportes/Filmes/Seriados/Documentários/Programas de auditório/Novela/Música/Religião}.split('/')
    end

=begin    
    def internet
      ["Wi-Fi",
      "3G",
      "Cabo"]
    end
=end

    def internet_frequencies
      ["Todo Dia",
      "Entre 2 e 6 dias por semana",
      "Uma vez por semana"]
    end
    
    def internet_places
      %{Celular/Computador próprio (em casa)/Distribuidoras/Na empresa/Lan-House/Notebook/Oficina/Palm/Postos de combustível}.split('/')
    end
    
    def internet_contents
      %{E-mail/Redes Sociais/Google/Notícias/Portais/Outros}.split('/')
    end
    
    def socials
      %{Facebook/Twitter/Orkut/Messenger/Youtube/Google Plus/Linkedin/Blogs/Outros}.split('/')
    end
    
    def sites
      %{Autocaminhões/Brasil Caminhoneiro/Brasilgransportes/Cowboys do Asfalto/Distribuidoras e Concessionárias/iCaminhões/O Carreteiro/Transponline/Transporte Mundial/Webtranspo/Outros}.split('/')
    end
  end
end
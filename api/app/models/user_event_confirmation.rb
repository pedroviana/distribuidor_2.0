# encoding: UTF-8

require 'csv'

class UserEventConfirmation < ActiveRecord::Base
  belongs_to :user_event
  has_one :user, through: :user_event
  has_one :event, through: :user_event
  has_one :midia_attachment
  
  before_save do |u|
    u.generate_report_csv
  end

  attr_accessor :name, :company,
                # csv accessors
                :le_revista, :revistas, :outra_revista,
                :le_jornal, :jornais,
                :ouve_radio, :radios, :tipo_musica, :outra_radio,
                :assisti_tv, :frequencia_tv, :canais, :canais_fechados, :outros_canais, :programas_preferidos, :outro_preferido,
                :envia_recebe_sms,
                :usa_internet, :tipo_internet, :frequencia_internet, :locais_internet, :o_que_ve_internet, :outros_sites_noticias, :outros_sites,
                :acessa_redes_sociais, :quais_redes_sociais, :quais_blogs, :outras_redes,
                :visita_site_especializado, :sites_especializados, :outro_site_especializado,
                # newspapers
                :jornais_acres,:jornais_acres_outro,
                :jornais_alagoass,:jornais_alagoass_outro,
                :jornais_amazonass,:jornais_amazonass_outro, 		
                :jornais_bahias,:jornais_bahias_outro, 			
                :jornais_cears,:jornais_cears_outro,			
                :jornais_distrito_federals,:jornais_distrito_federals_outro, 
                :jornais_esprito_santos,:jornais_esprito_santos_outro, 	
                :jornais_goiss,:jornais_goiss_outro, 			
                :jornais_goinias,:jornais_goinias_outro, 			
                :jornais_maranhos,:jornais_maranhos_outro, 		
                :jornais_mato_grosso_do_suls,:jornais_mato_grosso_do_suls_outro,
                :jornais_minas_geraiss,:jornais_minas_geraiss_outro, 	
                :jornais_parans,:jornais_parans_outro, 			
                :jornais_parabas,:jornais_parabas_outro, 			
                :jornais_pars,:jornais_pars_outro, 			
                :jornais_pernambucos,:jornais_pernambucos_outro, 		
                :jornais_piaus,:jornais_piaus_outro, 			
                :jornais_rio_grande_do_nortes,:jornais_rio_grande_do_nortes_outro,
                :jornais_rio_grande_do_suls,:jornais_rio_grande_do_suls_outro,
                :jornais_rio_de_janeiros,:jornais_rio_de_janeiros_outro,	
                :jornais_rondnias,:jornais_rondnias_outro, 		
                :jornais_roraimas,:jornais_roraimas_outro, 		
                :jornais_santa_catarinas,:jornais_santa_catarinas_outro, 	
                :jornais_so_paulos,:jornais_so_paulos_outro,		
                :jornais_sergipes,:jornais_sergipes_outro


#  def keys
#    [:name, :company, :email, :cep, :address, :state, :city, :cellnumber, :smartphone, :function, :complement, :number, :image_usage, :sms_usage, :email_usage]
#  end

  def other_keys
    %{Libera uso de imagem?/Libera envio de SMS?/Libera envio de e-mails?/Lê revistas?/Quais?/Outras/Lê Jornais?/Quais?/Acre/Outro/Alagoas/Outro/Amazonas/Outro/Bahia/Outro/Ceará/Outro/Distrito Federal/Outro/Espírito Santo/Outro/Goiás/Outro/Goiânia/Outro/Maranhão/Outro/Mato Grosso do Sul/Outro/Minas Gerais/Outro/Paraná/Outro/Paraíba/Outro/Pernambuco/Outro/Piauí/Outro/Rio Grande do Norte/Outro/Rio Grande do Sul/Outro/Rio De Janeiro/Outro/Rondônia/Outro/Roraima/Outro/Santa Catarina/Outro/São Paulo/Outro/Sergipe/Ouve Rádio?/O que ouve no rádio?/Que tipo de música ouve?/Outro/Assiste TV?/Com qualfrequência?/Quais canais gosta de ver na TV?/Outros/Qual(is) o(s) programa(s) preferido(s)?/Envia ou Recebe SMS?/Usa internet?/Com qual frequência usa a internet?/Locais onde acessa a internet:/O que costuma olhar na internet?/Quais redes sociais acessa?/Blogs/Outros/Visita algum site especializado em caminhões?/Quais sites?/Outro?}.split('/')
  end
  
  def generate_report_csv
    build_midia_attachment
    
    midia_attachment.file_file_name = 'midia_survey.csv'

    if midia_attachment.save
      path = "temp_midia_survey_#{self.code}.csv"
      begin
        File.delete(path)
      rescue Errno::ENOENT
      end
      
      file = File.new(path, 'w')
      file.close
      
      user_header = other_keys

      CSV.open( file, 'w' ) do |writer|
        writer<<other_keys
        #writer<<'\n'
        v = csv_methods.map! do |x|
          if x.is_a?(Array)
            x.reject!{ |c| c.empty? }.join(',')
          else
            x
          end
        end
        
        values = v.flatten
        raise values.inspect
        writer << values
      end
    end
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
  
  def csv_methods
    [
      image_usage, 
      sms_usage, 
      email_usage, 
      le_revista, 
      revistas, 
      outra_revista, 
      le_jornal, 
      jornais,
      jornais_acres,                jornais_acres_outro,
      jornais_alagoass,             jornais_alagoass_outro,
      jornais_amazonass,            jornais_amazonass_outro, 		
      jornais_bahias,               jornais_bahias_outro, 			
      jornais_cears,                jornais_cears_outro,			
      jornais_distrito_federals,    jornais_distrito_federals_outro, 
      jornais_esprito_santos,       jornais_esprito_santos_outro, 	
      jornais_goiss,                jornais_goiss_outro, 			
      jornais_goinias,              jornais_goinias_outro, 			
      jornais_maranhos,             jornais_maranhos_outro, 		
      jornais_mato_grosso_do_suls,  jornais_mato_grosso_do_suls_outro,
      jornais_minas_geraiss,        jornais_minas_geraiss_outro, 	
      jornais_parans,               jornais_parans_outro, 			
      jornais_parabas,              jornais_parabas_outro, 			
      jornais_pars,                 jornais_pars_outro, 			
      jornais_pernambucos,          jornais_pernambucos_outro, 		
      jornais_piaus,                jornais_piaus_outro, 			
      jornais_rio_grande_do_nortes, jornais_rio_grande_do_nortes_outro,
      jornais_rio_grande_do_suls,   jornais_rio_grande_do_suls_outro,
      jornais_rio_de_janeiros,      jornais_rio_de_janeiros_outro,	
      jornais_rondnias,             jornais_rondnias_outro, 		
      jornais_roraimas,             jornais_roraimas_outro, 		
      jornais_santa_catarinas,      jornais_santa_catarinas_outro, 	
      jornais_so_paulos,            jornais_so_paulos_outro,		
      jornais_sergipes,             jornais_sergipes_outro,
      ouve_radio, radios, tipo_musica, outra_radio, assisti_tv, frequencia_tv, canais, outros_canais, programas_preferidos, envia_recebe_sms, usa_internet, frequencia_internet, locais_internet, o_que_ve_internet, quais_redes_sociais, quais_blogs, outras_redes, visita_site_especializado, sites_especializados, outro_site_especializado
    ]
  end
  
  class << self
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
      %{Autocaminhões/Brasil Caminhoneiro/Brasilgransportes/Cowboys do Asfalto/Distribuidoras e Concessionárias/iCaminhões/O Carreteiro/Transponline/Transporte Mundial/Webtrranspo/Outros}.split('/')
    end
  end
end
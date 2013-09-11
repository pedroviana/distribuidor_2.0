# encoding: UTF-8

class UserEventConfirmation < ActiveRecord::Base
  belongs_to :user_event
  has_one :user, through: :user_event
  
  before_save :generate_report_csv

  attr_accessor :name, :company,
                # csv accessors
                :le_revista, :revistas, :outra_revista,
                :le_jornal, :jornais,
                :ouve_radio, :radios, :tipo_musica, :outra_radio,
                :assisti_tv, :frequencia_tv, :canais, :canais_fechados, :outros_canais, :programas_preferidos, :outro_preferido,
                :envia_recebe_sms,
                :usa_internet, :tipo_internet, :frequencia_internet, :locais_internet, :o_que_ve_internet, :outros_sites_noticias, :outros_sites,
                :acessa_redes_sociais, :quais_redes_sociais, :quais_blogs,
                :visita_site_especializado, :sites_especializados, :outro_site_especializado
  
  def generate_report_csv
    
  end
  
  def name
    user.name
  end
  
  def company
    user.company
  end
  
  class << self
    def magazines
      ["O Carreteiro",
      "Caminhoneiro",
      "Na Boléia",
      "Transpomagazine",
      "Transporte Mundial",
      "Veja",
      "Época",
      "Isto É",
      "Outra"]
    end
    
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
      "Uma vez por semana",
      "Raramente"]
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
      ["Novelas",
      "Esporte",
      "Notícias",
      "Filmes",
      "Seriados",
      "Programas de Auditório",
      "Documentários", 
      "Outros"]
    end
    
    def internet
      ["Wi-Fi",
      "3G",
      "Cabo"]
    end
    
    def internet_frequencies
      ["Todo Dia",
      "Entre 2 e 6 dias por semana",
      "Uma vez por semana",
      "Raramente"]
    end
    
    def internet_places
      ["Lan-house",
      "Posto de Combustível",
      "Computador próprio (no caminhão)",
      "Computador próprio (em casa)",
      "Celular",
      "Distribuidor / Concessionária"]
    end
    
    def internet_contents
      ["E-mail",
      "Site de Notícias",
      "Outros"]
    end
    
    def socials
      ["Orkut",
      "Facebook",
      "YouTube",
      "Twitter",
      "Skype",
      "Blogs"]
    end
    
    def sites
      ["O Carreteiro",
      "Transporte Mundial",
      "Webtranspo",
      "Trasnponline",
      "iCaminhões",
      "Sites de Distribuidores / Concessionárias",
      "Caminhoneiro",
      "Brasil Caminhoneiro",
      "Outro"]
    end
  end
end

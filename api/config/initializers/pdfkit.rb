PDFKit.configure do |config|
  config.wkhtmltopdf = '/usr/local/rvm/gems/ruby-1.9.3-p448/bin/wkhtmltopdf'
  config.default_options = {
    :page_size => 'A4',
    :print_media_type => true
  }
  # Use only if your external hostname is unavailable on the server.
#  config.root_url = "http://localhost" 
end
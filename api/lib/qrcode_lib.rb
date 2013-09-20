require 'rqrcode'
require 'rqrcode-rails3/size_calculator.rb'
require 'rqrcode-rails3/renderers/svg.rb'
 
class LibQRCode
  
  def self.generate_qrcode(text, options)
    size = options[:size] 
    level = options[:level] || :h
 
    qrcode = RQRCode::QRCode.new(text, :size => size, :level => level)
    svg = RQRCode::Renderers::SVG::render(qrcode, options)
     
    filename = SecureRandom.hex(12)+'.svg'
    directory = Rails.public_path.to_s + "/qrcodes"
    File.open(File.join(directory, filename), 'w') do |f|
      f.puts svg
    end

    image = MiniMagick::Image.open(File.join(directory, filename)) { |i| i.format "svg" }
    image.format 'jpeg'
    new_path = File.join(directory, filename).gsub('.svg', '.jpeg').to_s rescue nil
    image.write new_path
    new_path  
  end
end
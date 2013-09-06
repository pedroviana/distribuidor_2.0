class QrController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.svg  { render :qrcode => "pedro.viana.pav@gmail.com", :level => :l, :unit => 10 }
      format.png  { render :qrcode => "pedro.viana.pav@gmail.com" }
      format.gif  { render :qrcode => "pedro.viana.pav@gmail.com" }
      format.jpeg { render :qrcode => "pedro.viana.pav@gmail.com" }
    end
  end
end

require 'rubygems'
require 'nokogiri'
require 'pry'
require 'base64'
require  'httparty'


#Target scrape invoice num
base_url = "http://extranet.tcp.com.br/extranet/agendamento/app/hermes/invoice.php?FATURA="

invoice_num = 13231898

while invoice_num > 0 do

invoice_num64 = Base64.encode64(invoice_num.to_s)

target_url = "#{base_url}#{invoice_num64}"

response = HTTParty.get(target_url)

page = Nokogiri::HTML(response.body)

binding.pry

i = Invoice.find_or_create_by(invoice_num: page.css("th.medx").text().gsub(/\D+/, ''))
  i.attributes = {
    :invoice_num => page.css("th.medx").text().gsub(/\D+/, ''),
    #:invoice_url => XX,
    #:service => XX,
    :emission_date => page.css('tbody > td[4]').text,
    :due_date => page.css('tbody > td[5]').text,
    :pay_date => page.css('tbody > td[6]').text,
    :pay_status => page.css('tbody > td[7]').text,
    :email => page.css('tbody > tr > td:nth-child(2)').text # needs revision
  }
  i.save



fonts = page.css('tr > td > font')
c = Client.find_or_create_by(client_code: fonts[11].text)
  c.attributes = {
    :client_name => fonts[9].text,
    :client_code => fonts[11].text,
    :client_address => fonts[13].text,
    :client_cep => fonts[15].text,
  }
  c.save

# o = O.find_or_create_by os_num('OS CSS ADDRESS')
#   o.attributes = {
#     :os_num => ,
#     :os_url => page.css('tr > td > a')
#   }
#   o.save

# for each expense line
    # e = Expense.new
    # e.attributes = {
        # e.description => 
        # e.weight => 
        # e.value => 
        # e.emaster =>  
        # e.cehouse =>
        # e.di =>
        # e.invoice_id => i.invoice_id
    #}

invoice_num-=1

end





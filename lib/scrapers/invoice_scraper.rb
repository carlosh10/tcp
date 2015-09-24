require 'rubygems'
require 'nokogiri'
require 'pry'
require 'base64'
require  'httparty'

#Target scrape invoice num

invoice_num = '13231898'
invoice_num64 = Base64.encode64(invoice_num)

puts invoice_num
puts invoice_num64

base_url = "http://extranet.tcp.com.br/extranet/agendamento/app/hermes/invoice.php?FATURA="

target_url = base_url + invoice_num64

response = HTTParty.get(target_url)

invoice_nokogiri = Nokogiri::HTML(response.body)


# if invoice does not exist, create invoice
iii = invoice_nokogiri.css('body > table > tbody > tr > th:nth-child(2)')

i = Invoice.new
i.attributes = {
  :invoice_num => iii[1],
  :invoice_date => iii[2],
  :invoice_url => iii[3]
}

i.save


# if Client does not exist, create client

fonts = invoice_nokogiri.css('tr > td > font')
c = Client.new
c.attributes = {
  :client_name => fonts[9].text,
  :client_code => fonts[11].text,
  :client_address => fonts[13].text,
  :clients_cep => fonts[15].text,
}
c.save


# if O does not exist, create O
ooo = invoice_nokogiri.css('#datagrid-row-r4-2-0 > td:nth-child(2) > div > a')
o = O.new
o.attributes = {
  :o_num => ooo[1],
  :o_url => ooo[2]
}
o.save

pry.biding

# if appearance does not exist, create appearance
aaa = invoice_nokogiri.css('####')
a = Appearance.new
a.attributes = {
  :invoice_id => aaa[1],
  :o_id => aaa[2]
}
a.save


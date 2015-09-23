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

fonts = invoice_nokogiri.css('tr > td > font')
client_name = fonts[9].text
client_code = fonts[11].text
client_address = fonts[13].text
clients_cep = fonts[15].text

binding.pry


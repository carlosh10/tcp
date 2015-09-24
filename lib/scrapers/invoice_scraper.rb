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

puts page.css('td[7]')

binding.pry

i = Invoice.find_or_create_by(invoice_num: page.css("th.medx").text().gsub(/\D+/, ''))
  i.attributes = {
    :invoice_num => page.css("th.medx").text().gsub(/\D+/, ''),
    :invoice_url => page.url,
    :service => page.css(".datagrid-cell .datagrid-cell-c2-name2").text(),
    :emission_date => page.css("datagrid-cell datagrid-cell-c1-name5"),
    :due_date => page.css("datagrid-cell datagrid-cell-c1-name6"),
    :pay_date => page.css("datagrid-cell datagrid-cell-c1-name7"),
    :pay_status => page.css("datagrid-cell datagrid-cell-c1-name10"),
    :email => page.css("datagrid-cell datagrid-cell-c5-name2")
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

# o = O.find_or_create_by_os_num('OS CSS ADDRESS')
#   o.attributes = {
#     :os_num => ,
#     :os_url => page.css('tr > td > a')
#   }
#   o.save

invoice_num-=1

end




# # if O does not exist, create O
# ooo = invoice_nokogiri.css('a')
# o = O.new
# o.o_num = ooo[13].text
# o.o_url = ooo[14].text
# o.save

# # if invoice does not exist, create invoice

# i = Invoice.new
# i.invoice_num = invoice_nokogiri.css('.medx')
# i.client_code = fonts[11].text
# i.services = invoice_nokogiri.css('.datagrid-cell-c2-name2')

# i.save


# # if appearance does not exist, create appearance
# a = Appearance.new
# a.invoice_num = i.invoice_num
# a.o_num = o.o_num
# a.save



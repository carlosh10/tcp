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



i = Invoice.find_or_create_by(invoice_num: page.css("th.medx").text().gsub(/\D+/, ''))
  i.attributes = {
    :invoice_num => page.css("th.medx").text().gsub(/\D+/, ''),
    #:invoice_url => XX, 
    #Is this not target_url?
    :service => page.css("#p")[2].to_xml,
    #For service, if you are not immediately sure what you are going to need it for, and thus we can be lazy and just store the entire section, I use postgres's XML datatype for this column and store it has XML for later use
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

i.update_attribute(:client_id, c.id)



#select all of the ordems de servicio
page.css("#p")[4].css("tr")[1..-1].each do |ordem_row|
  ordem_line = ordem_row.children

  ordem = O.find_by(os_num: ordem_line[3].text)

  if ordem == nil
    ordem = O.new({
      os_num: ordem_line[3].text,
      os_url: ordem_line[3].css("a").attr("href").value
    })

    binding.pry
    
    ordem.save
  end

i.update_attribute(:order_id, ordem.id)

end





# for each expense line
# notes: uses [1..-1] range to throw out header row.
page.css("#p")[3].css("tr")[1..-1].each do |expense_row|
    expense_line = expense_row.children
    e = Expense.new({
        description: expense_line[0].text.strip,
        weight: expense_line[1].text.strip,
        value: expense_line[2].text.strip,
        cemaster: expense_line[3].text.strip,
        cehouse: expense_line[4].text.strip,
        di: expense_line[5].text.strip,
        invoice_id: i.invoice_id
    })

    e.save
end

invoice_num-=1

end





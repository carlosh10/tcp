require 'rubygems'
require 'nokogiri'
require 'pry'
require 'base64'
require 'httparty'
require 'iconv'
require 'action_view'

include  ActionView::Helpers::SanitizeHelper

puts 'starting proccess'

# Target scrape invoice num
base_url = "/data/crawler/invoices/"

invoice_num = 13000000

invoice_max = 13239050


Parallel.each((invoice_num..invoice_max).to_a, in_threads: 1) do |num|

  puts num

  begin

    target_url = "#{base_url}#{num}.html"

    # target_url = "/home/alvaro/Downloads/INVOICE TCP.html"

    unless File.exist?(target_url)
      next
    end

    response = File.open(target_url, 'r:iso-8859-1:utf-8')

    page = Nokogiri::HTML(response)

    unless page.css("#p").count >= 2
      next
    end


    i = Invoice.find_or_create_by(invoice_num: page.css("th.medx").text().gsub(/\D+/, ''))


    ##
    #i = Invoice.new

    i.attributes = {
      :invoice_num => page.css("th.medx").text().gsub(/\D+/, ''),
      #:invoice_url => XX,
      #Is this not target_url?
      :service => strip_tags(page.css("#p")[2].css("tbody td").to_s).to_s.squish,
      #For service, if you are not immediately sure what you are going to need it for, and thus we can be lazy and just store the entire section, I use postgres's XML datatype for this column and store it has XML for later use
      :emission_date => page.css('tbody > td[4]').text,
      :due_date => page.css('tbody > td[5]').text,
      :pay_date => page.css('tbody > td[6]').text,
      :pay_status => page.css('tbody > td[7]').text,
      :email => page.xpath("//*[@id='datagrid-row-r5-2-0']/td[2]/div").text,
      :value => page.xpath("//*[@id='p']/div/h2")[0].children[0].to_s.sub(',','.').gsub(/[^.0-9]/, '').to_f
    }

    i.save

    # binding.pry


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


    unless page.css("#p").count >= 4
      next
    end

    #select all of the ordems de servicio
    page.css("#p")[4].css("tr")[1..-1].each do |ordem_row|

      ordem_line = ordem_row.children

      if ordem_line.count < 3 || ordem_line[3].css("a") == [] || ordem_line[3].css("a").count == 0
        invoice_max -= 1
        next
      end

      ordem = O.find_by(os_num: ordem_line[3].text)


      if ordem == nil

        ordem = O.new({
                        os_num: ordem_line[3].text,
                        os_url: ordem_line[3].css("a").attr("href").value,
                        services: Array.new,
                        historics: Array.new
        })

        #os_url = '#{ordem.os_url.split('=').last}.html'

        os_url = '/home/alvaro/Downloads/ORDEM DE SERVICO TCP.html'



        if File.exist?(os_url)

          os_file = File.open(os_url, 'r:iso-8859-1:utf-8')

          os_page = Nokogiri::HTML(os_file)

          table = os_page.xpath("//*[@id='p']/div/table")

          msg = os_page.xpath("//*[@id='p']/div/div/text()").text.to_s.squish.split(' ')

          ordem.ce = msg[1]
          ordem.di = msg [3]
          ordem.retirada = msg[6]
          ordem.cif_value = msg[9].to_s.sub('.','').sub(',','.').to_f
          ordem.total_value = msg[14].to_s.sub('.','').sub(',','.').to_f

          header = os_page.xpath("/html/body/table/tbody/tr/th[2]")

          begin

            ordem.number = header.text.split(' ')[6].to_i
            ordem.turn = header.text.split(' ')[8].to_i
            ordem.created = Date.parse header.text.split(' ')[9]

            #binding.pry

          rescue Exception => e1

          end





          table.css('tbody tr').each do |tr|

            tds = tr.xpath('./td')


            ordem.services << Service.new({
                                            quantity: tds[0].css('small')[0].text.to_i,
                                            service: tds[1].css('small')[0].text.to_s,
                                            value: tds[2].css('small')[0].text.gsub(',','.').to_s.sub(',','.').gsub(/[^.0-9]/, '').to_f
            })



          end

          historics = os_page.xpath("/html/body/div[6]/div[2]/table/tbody")

          historics.css('tr').each do  |tr|

            tds = tr.xpath('./td')


            ordem.historics << Historic.new({
                                              moment: tds[0].text,
                                              user: tds[1].text,
                                              historic: tds[2].text
            })

            #   binding.pry

          end

        end


        ordem.save


      end

      i.update_attribute(:o_id, ordem.id)

    end

    #//*[@id="p"]/div[2]/div/div/div[2]/div[2]/table/tbody
    #/html/body/div[4]/div[2]/div[2]/div/div/div[2]/div[2]/table/tbody

    page.xpath("/html/body/div[4]/div[2]/div[2]/div/div/div[2]/div[2]/table/tbody").css("tr")[1..-1].each do |expense_row|

      expense_line = expense_row.children
      e = Expense.new({
                        description: expense_line[0].text.strip,
                        weight: expense_line[1].text.strip,
                        value: expense_line[2].text.strip,
                        cemaster: expense_line[3].text.strip,
                        cehouse: expense_line[4].text.strip,
                        di: expense_line[5].text.strip,
                        invoice_id: i.id
      })

      binding.pry
      e.save

    end

  rescue => e
    puts "caught exception #{e}! ohnoes!"
  end

end

puts 'end proccess'

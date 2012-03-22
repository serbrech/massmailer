require 'CSV'
require 'colorize'
require './config.rb'
require './validator.rb'

def mail_body datarow
  content = File.read(CONFIG['email']['body_file'])
  datarow.headers.each do |h|
    content.gsub!("\{#{h}\}", datarow[h]) unless datarow[h].nil?
  end
  content
end

def send_mass_mail datarow
  if is_valid_email(datarow["Email"])
    mail = Mail.new do
      from    CONFIG['email']['from_name']
      to      datarow["Email"]
      subject CONFIG['email']['subject']
      body    mail_body(datarow)
    end
    mail.charset = 'UTF-8'
    # puts mail_body(datarow)

    # response = mail.deliver!
    puts "sent to #{datarow['Name']}".green
  else
    puts "failed to send to #{datarow['Name']} : #{datarow['Email']}!".red
  end  
end

CSV.foreach(CONFIG['email']['csv_file'], :col_sep =>';', :row_sep =>:auto, :headers => true, encoding: "UTF-8") do |row|
  send_mass_mail(row)
end
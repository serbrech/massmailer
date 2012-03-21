require 'mail'
require 'CSV'
require 'yaml'

CONFIG = YAML.load_file('config.yml')

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'gmail.com',
            :user_name            => CONFIG['gmail']['username'],
            :password             => CONFIG['gmail']['password'],
            :authentication       => 'plain',
            :return_response => true,
            :enable_starttls_auto => true  }
            
Mail.defaults do
  delivery_method :smtp, options
end

def mail_body datarow
  content = File.read(CONFIG['email']['body_file'])
  datarow.headers.each do |h|
    content.gsub!("\{#{h}\}", datarow[h])
  end
end

def send_mass_mail datarow
  mail = Mail.new do
    from    CONFIG['email']['from_name']
    to      datarow["email"]
    subject CONFIG['email']['subject']
    body    mail_body(datarow)
  end
  response = mail.deliver!
  p response
  p "failed : #{response}" unless response.status == "250"
  p "sent to #{datarow['name']}" if response.status == "250"  
end

CSV.foreach(CONFIG['email']['csv_file'], :headers => true) do |row|
  send_mass_mail(row)
end